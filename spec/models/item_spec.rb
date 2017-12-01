require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to(:restaurant).inverse_of(:items) }
  it { should belong_to(:item_type).inverse_of(:items) }
  it { should belong_to(:user).inverse_of(:items) }
  it { should have_many(:content_berries).inverse_of(:item).dependent(:destroy) }
  it { should have_many(:allergens).through(:item_allergens) }
  it { should have_many(:item_allergens).inverse_of(:item) }
  it { should have_many(:ingredients).through(:item_ingredients) }
  it { should have_many(:item_ingredients).inverse_of(:item).dependent(:destroy) }
  it { should have_many(:item_diets).inverse_of(:item).dependent(:destroy) }
  it { should have_many(:diets).through(:item_diets) }
  it { should have_many(:recipe_items).inverse_of(:item).dependent(:destroy) }
  it { should have_many(:item_comments).inverse_of(:item) }
  it { should have_many(:comments).through(:item_comments) }
  it { should have_one(:recipe).inverse_of(:item).dependent(:destroy) }

  it { should validate_presence_of(:name) }

  it { should delegate_method(:image_path_suffix).to(:restaurant).with_prefix true }
  it { should delegate_method(:path_name).to(:restaurant).with_prefix true }
  it { should delegate_method(:name).to(:restaurant).with_prefix true }

  it { is_expected.to callback(:no_image_file_notification).after(:save) }
  it { is_expected.to callback(:process_item_diets).before(:save) }

  describe 'Init' do
    let(:item_type) { FactoryGirl.create(:item_type, name: 'other') }
    let(:item) { FactoryGirl.create(:item)}

    it 'when the item_type is nil its set it to "other"' do
      item_type

      expected = item_type
      actual = item.item_type

      expect(actual).to eq expected
    end
  end

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

  describe '.sort_by_scope' do
    let(:item_type) { FactoryGirl.create(:item_type, name: ItemType.names.first) }
    let(:item) { FactoryGirl.create(:item, item_type: item_type) }

    before do
      item
    end

    it 'returns hash with items mapped to their type' do
      item_type
      item

      actual = Item.sort_by_scope(Item.all)

      expect(actual[item_type.name.to_sym]).to include item
    end

    it 'uses "other" scope correctly, and include items with nil types' do
      item.update_attribute(:item_type,  nil)

      item_type

      actual = Item.sort_by_scope(Item.all)

      expect(actual[:other]).to include item
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
        item.allergen_string = nil

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
        item.allergen_string = 'CONTAINS: EGGS'

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

    before { item }
    context 'with fl oz' do
      let(:beverarge_name) { 'Coke (20 fl oz)' }
      let(:item) {FactoryGirl.create(:item, name: beverarge_name)}

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

    context 'with (child, medium large)' do
      let(:beverarge_name) { 'Coke (Large)' }
      let(:item) {FactoryGirl.create(:item, name: beverarge_name)}

      it 'does not create a duplicate beverage' do
        item_count = Item.count

        Item.create(name: 'Coke (Medium)', restaurant: item.restaurant)

        actual = Item.count

        expect(actual).to eq(item_count)
      end

      it 'throws an error' do
        new_item = Item.new(name: 'Coke (Child)', restaurant: item.restaurant)
        new_item.save

        name_error_msgs = new_item.errors.messages[:name]
        expect(name_error_msgs).to include(Item::BEVERAGE_UNIQUENESS_ERROR_MSG)
      end
    end
  end

  describe 'item diets based on recipes' do
    let(:recipe_item) { FactoryGirl.create(:recipe_item) }
    let(:item_diet) { FactoryGirl.build(:item_diet, item: recipe_item.item) }
    let(:diet) { item_diet.diet }
    let(:recipe) { recipe_item.recipe }
    let(:item_with_recipe) { recipe.item }
    let(:generator) { double(:generator) }

    context 'items with recipes diets change when the recipe diets change' do
      it 'creates an item diet when a recipe diet is added' do
        item_diet_for_item_with_recipe = FactoryGirl.build(:item_diet, item: item_with_recipe, diet: diet)
        allow(ItemDietGenerator).to receive(:new) { generator }
        allow(generator).to receive(:generate) { [item_diet_for_item_with_recipe] }

        item_diet.save
        item_with_recipe.reload

        expect(item_with_recipe.item_diets).not_to be_empty
      end

      it 'removes an item diet when a recipe diet is removed' do
        allow(ItemDietGenerator).to receive(:new) { generator }
        allow(generator).to receive(:generate) { [] }

        FactoryGirl.create(:item_diet, item: item_with_recipe, diet: diet)

        item_diet.save
        item_with_recipe.reload

        expect(item_with_recipe.item_diets).to be_empty
      end
    end
  end

  describe 'after create' do
    it 'gives a default berry to the creator' do
      user = FactoryGirl.create(:user)
      content_berries_count = ContentBerry.count
      FactoryGirl.create(:item, user: user)

      actual = ContentBerry.count

      expect(actual).to eq content_berries_count + 1
      expect(ContentBerry.last.user).to eq user
    end
  end

  describe '#no_image_file_notification' do
    # add the tests to make sure stuff is logged and outputed to the console
  end
end

RSpec.describe Item, type: :model do
  it { should validate_uniqueness_of(:name).scoped_to(:restaurant_id).case_insensitive }
end
