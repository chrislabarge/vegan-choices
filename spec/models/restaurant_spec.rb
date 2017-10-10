require 'rails_helper'

RSpec.describe Restaurant, type: :model do

  before do
    allow_any_instance_of(Restaurant).to receive(:no_image_file_notification)
  end

  it { should have_many(:item_listings).inverse_of(:restaurant) }
  it { should have_many(:items).inverse_of(:restaurant) }
  it { should have_many(:diets).through(:items) }
  it { should have_many(:item_ingredients).through(:items) }
  it { should have_many(:restaurant_comments).inverse_of(:restaurant) }
  it { should have_many(:comments).through(:restaurant_comments) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { is_expected.to callback(:create_image_dir).after(:create) }
  it { is_expected.to callback(:update_image_dir).after(:save) }
  it { is_expected.to callback(:no_image_file_notification).after(:save) }

  describe '#view_count' do
    let(:restaurant) { Restaurant.create(name: 'foo') }

    it 'defaults to 0' do
      expect(restaurant.view_count).to eq 0
    end
  end

  describe '#menu_items' do
    let(:restaurant) { FactoryGirl.create(:restaurant) }
    let(:menu_item_type) { FactoryGirl.create(:item_type, name: ItemType::MENU) }
    let(:another_item_type) { FactoryGirl.create(:item_type) }

    before do
      menu_item_type
    end

    context 'when an item has a "Menu" ItemType' do
      let(:item) { FactoryGirl.create(:item, restaurant: restaurant, item_type_id: menu_item_type.id) }
      it 'is included in the collection of restaurants menu items' do
        actual = restaurant.menu_items

        expect(actual).to include item
      end
    end

    context 'when an item has a "Menu" ItemType' do
      let(:item) { FactoryGirl.create(:item, restaurant: restaurant, item_type_id: another_item_type.id) }
      it 'is included in the collection of restaurants menu items' do
        actual = restaurant.menu_items

        expect(actual).not_to include item
      end
    end
  end

  describe '#non_menu_items' do
    let(:restaurant) { FactoryGirl.create(:restaurant) }
    let(:non_menu_item_type) { FactoryGirl.create(:item_type) }
    let(:menu_item_type) { FactoryGirl.create(:item_type, name: ItemType::MENU) }

    before do
      non_menu_item_type
      menu_item_type
    end

    context 'when an item has a "Non-Menu" ItemType' do
      let(:item) { FactoryGirl.create(:item, restaurant: restaurant, item_type_id: non_menu_item_type.id) }
      it 'is included in the collection of restaurant non menu items' do
        actual = restaurant.non_menu_items

        expect(actual).to include item
      end
    end

    context 'when an item has a "Menu" ItemType' do
      let(:item) { FactoryGirl.create(:item, restaurant: restaurant, item_type_id: menu_item_type.id) }
      it 'is not included in the collection of restaurant non menu items' do
        actual = restaurant.non_menu_items

        expect(actual).not_to include item
      end
    end

    context 'when an item does not have an ItemType' do
      let(:item) { FactoryGirl.create(:item, restaurant: restaurant) }
      it 'is included in the collection of restaurant non menu items' do
        actual = restaurant.non_menu_items

        expect(actual).to include item
      end
    end

    context 'when there are 2 items, one with a (non-menu) ItemType and one without' do
      let(:item) { FactoryGirl.create(:item, restaurant: restaurant) }
      let(:another_item) { FactoryGirl.create(:item, restaurant: restaurant, item_type_id: non_menu_item_type.id) }

      it 'returns both items in the collection' do
        actual = restaurant.non_menu_items

        expect(actual).to include item, another_item
      end
    end
  end

  describe 'image directory callbacks' do
    let(:name) { 'Some Name' }
    let(:new_name) { 'Another Name' }
    let(:restaurant) { Restaurant.create(name: name) }

    before do
      allow_any_instance_of(Restaurant).to receive(:no_image_file_notification)
    end

    it 'creates an image directory' do
      expect(File.directory?(restaurant.send(:image_dir))).to eq true
    end

    it 'updates the directory name when the name changes' do
      previous_dir = restaurant.send(:image_dir)
      restaurant.name = new_name

      restaurant.save

      expect(File.directory?(previous_dir)).to eq false
      expect(File.directory?(restaurant.send(:image_dir))).to eq true
    end

    after(:each) do
      image_dir = restaurant.send(:image_dir)
      FileUtils.remove_dir(image_dir)
    end
  end

  describe '.search' do
    let(:name) { "McDonald's" }
    let(:restaurant) { FactoryGirl.create(:restaurant, name: name) }

    context 'returns search results that include the restaurant when' do
      it 'receives the exact restaurant name' do
        results = Restaurant.search(name)

        expect(results).to include restaurant
      end

      it 'receives the lower case restaurant name' do

        results = Restaurant.search(name.downcase)

        expect(results).to include restaurant
      end

      it 'receives the non punctuated restaurant name' do
        non_punctuated = name.gsub!(/\W+/, '')

        results = Restaurant.search(non_punctuated)

        expect(results).to include restaurant
      end

      it 'receives the first character of the restaurant name' do
        first_character = name[0]

        results = Restaurant.search(first_character)

        expect(results).to include restaurant
      end
    end

    context 'when searching for an non existing restaurant' do
      it 'returns an empty collection' do
        name = 'non existing restaurant name'

        results = Restaurant.search(name)

        expect(results).to be_empty
      end
    end
  end

  describe '#image_path' do
    let(:item) { FactoryGirl.build_stubbed(:item, name: 'Some Item') }
    let(:restaurant_path_name) { 'some_restaurant' }
    it 'returns the image path' do
      allow(item).to receive(:restaurant_path_name) { '' }
      path_name = 'app/assets/images/restaurants/some_restaurant/items/some_item.jpeg'

      allow(Dir).to receive(:[]) { [path_name] }

      path = item.image_path

      expect(path).to eq 'restaurants/some_restaurant/items/some_item.jpeg'
    end
  end

  describe '#generate' do
    let(:item) { FactoryGirl.create(:item) }
    let(:restaurant) { item.restaurant }
    let(:existing_item) { FactoryGirl.create(:item, restaurant: restaurant) }

    it 'generates a recipe with recipe items' do
      item.update(ingredient_string: existing_item.name)

      restaurant.generate_recipes

      item.reload

      recipe = item.recipe
      items = recipe.items

      expect(recipe).not_to eq nil
      expect(items).to include existing_item
    end

    context 'does not generate a recipe with recipe items when' do
      it 'receives an item with no recipe items within the #ingredient_string' do

        actual = restaurant.generate_recipes

        item.reload

        recipe = item.recipe

        expect(actual).not_to eq true
        expect(recipe).to eq nil
      end

      it 'receives an item with a nil #ingredient_string' do
        item.update(ingredient_string: nil)

        actual = restaurant.generate_recipes

        item.reload

        recipe = item.recipe

        expect(actual).not_to eq true
        expect(recipe).to eq nil
      end
    end
  end
end
