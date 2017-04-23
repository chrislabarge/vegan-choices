require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to(:restaurant).inverse_of(:items) }
  it { should belong_to(:item_type).inverse_of(:items) }
  it { should have_many(:ingredients).through(:item_ingredients) }
  it { should have_many(:item_ingredients).inverse_of(:item).dependent(:destroy) }
  it { should have_many(:item_diets).inverse_of(:item).dependent(:destroy) }
  it { should have_many(:diets).through(:item_diets) }

  it { should validate_presence_of(:name) }

  it { should delegate_method(:image_path_suffix).to(:restaurant).with_prefix true }
  it { should delegate_method(:path_name).to(:restaurant).with_prefix true }
  it { should delegate_method(:name).to(:restaurant).with_prefix true }

  it { is_expected.to callback(:no_image_file_notification).after(:save) }
  it { is_expected.to callback(:process_item_diets).before(:save) }

  describe 'scope' do
    context 'Type' do
      before :all do
        create_all_item_types
      end

      after :all do
        destroy_all_item_types
      end

      it 'scopes the ItemType' do
        ItemType.all.each do |type|
          item = FactoryGirl.create(:item, item_type: type)

          scope = type.name.to_sym
          items_scoped_to_type = Item.send(scope)

          expect(items_scoped_to_type).to include item
        end
      end

      it 'scopes no item type to "other"' do
        item = FactoryGirl.create(:item)
        items_scoped_to_type = Item.other

        expect(items_scoped_to_type).to include item
      end
    end

    context 'Diet' do
      before :all do
        create_all_diets
      end

      after :all do
        destroy_all_diets
      end

      it 'scopes the Diet' do
        Diet.all.each do |diet|
          item_diet = FactoryGirl.create(:item_diet, diet: diet)
          item = item_diet.item

          scope = diet.name.to_sym
          items_scoped_to_diet = Item.send(scope)

          expect(items_scoped_to_diet).to include item
        end
      end
    end
  end

  describe '#main_item_ingredients' do
    let(:item) { FactoryGirl.create(:item, name: 'some item') }
    let(:item_ingredient) { FactoryGirl.create(:item_ingredient, item: item) }
    it 'returns the main item_ingredients' do
      item_ingredients = item.main_item_ingredients

      expect(item_ingredients).to include item_ingredient
    end
  end

  describe 'processesing item diets' do
    let(:item) { FactoryGirl.build(:item) }
    let(:item_diet) { FactoryGirl.build(:item_diet, item: item) }
    before do
      item_diet
    end

    context 'an item creates item diets when' do
      let(:generator) {double('generator')}
      it 'is saved and applicable to a diet' do
        allow(ItemDietGenerator).to receive(:new) { generator }
        allow(generator).to receive(:generate) { [item_diet] }

        item.save

        item_diets = item.item_diets

        expect(item_diets.present?).to eq true
      end
    end

    context 'an item does NOT create item diets when' do
      it 'is saved and does not have the proper dietary attributes' do
        item.ingredient_string = nil
        item.allergens = nil

        item.save

        item_diets = item.item_diets

        expect(item_diets.empty?).to eq true
      end

      it 'is saved and non applicable to a diet' do
        generator = ItemDietGenerator.new(item)
        allow(ItemDietGenerator).to receive(:new) { generator }
        allow(generator).to receive(:can_generate_item_diets?) { true }
        allow(generator).to receive(:find_applicable_diets_for_item) { [] }

        item.save

        item_diets = item.item_diets

        expect(item_diets.empty?).to eq true
      end
    end

    context 'an item deletes item diets when' do
      let(:item_diet) { FactoryGirl.create(:item_diet) }
      let(:item) { item_diet.item }

      it 'is saved and no longer applicable to a diet' do
        allow(item).to receive(:any_dietary_changes?) { true }

        item.save

        item_diets = item.item_diets

        expect(item_diets.empty?).to eq true
      end
    end
  end

  describe '#path_name' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    it 'substitutes spaces for underscores' do
      name = 'Some Item'

      allow(item).to receive(:name) { name }

      path_name = item.path_name

      expect(path_name).to eq 'some_item'
    end

    it 'downcases' do
      name = 'Item'

      allow(item).to receive(:name) { name }

      path_name = item.path_name

      expect(path_name).to eq 'item'
    end

    it 'removes punctuation' do
      name = "Item's"

      allow(item).to receive(:name) { name }

      path_name = item.path_name

      expect(path_name).to eq 'items'
    end

    it 'accepts arguments' do
      name = 'Some Argument Name'
      path_name = item.path_name(name)

      expect(path_name).to eq 'some_argument_name'
    end
  end

  describe '#image_path' do
    let(:item) { FactoryGirl.build_stubbed(:item, name: 'Some Item') }
    let(:restaurant_path_name) { 'some_restaurant' }

    before do
      allow(item).to receive(:restaurant_image_path_suffix) { '' }
    end

    context 'with image asset' do
      it 'returns the image path' do
        path_name = 'app/assets/images/restaurants/some_restaurant/items/some_item.jpeg'

        allow(Dir).to receive(:[]) { [path_name] }

        path = item.image_path

        expect(path).to eq 'restaurants/some_restaurant/items/some_item.jpeg'
      end
    end

    context 'without image asset' do
      it 'returns a placeholder string' do
        allow(Dir).to receive(:[]) { [] }

        path = item.image_path

        expect(path).to eq nil
      end
    end

    context 'without #image_path_suffix definded' do
      it 'returns an error' do
        allow(item).to receive(:respond_to?) { nil }

        begin
          item.image_path
        rescue Error::UndefinedMethod
          error_thrown = true
        end

        expect(error_thrown).to eq true
      end
    end
  end

  describe '#any_dietary_changes?' do
    let(:item) { FactoryGirl.build_stubbed(:item) }

    context 'returns true when' do
      it 'the item\'s allergens attribute has changed'  do
        item.allergens = 'CONTAINS: EGGS'

        actual = item.any_dietary_changes?

        expect(actual).to eq true
      end

      it 'the item\'s ingredient_string attribute has changed'  do
        item.ingredient_string = 'some ingredient'

        actual = item.any_dietary_changes?

        expect(actual).to eq true
      end

      it 'the item\'s name attribute has changed'  do
        item.name = 'Some Item'

        actual = item.any_dietary_changes?

        expect(actual).to eq true
      end
    end
  end

  describe 'validates uniquess of beverage name when there are multiple sizes' do
    let(:beverarge_name) { 'Coke (20 fl oz)' }
    let(:item) {FactoryGirl.create(:item, name: beverarge_name)}

    before { item }

    it 'does not create a duplicate beverage' do
      item_count = Item.count

      Item.create(name: 'Coke (30 fl oz)', restaurant: item.restaurant)

      actual = Item.count

      expect(actual).to eq(item_count)
    end

    it 'throws an error' do
        new_item = Item.new(name: 'Coke (30 fl oz)', restaurant: item.restaurant)
        new_item.save

        name_error_msgs = new_item.errors.messages[:name]
        expect(name_error_msgs).to include(Item::BEVERAGE_UNIQUENESS_ERROR_MSG)
    end
  end

  describe '#no_image_file_notification' do
    # add the tests to make sure stuff is logged and outputed to the console
  end
end

RSpec.describe Item, type: :model do
  it { should validate_uniqueness_of(:name).scoped_to(:restaurant_id).case_insensitive }
end
