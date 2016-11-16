require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it { should have_many(:ingredient_lists).inverse_of(:restaurant)}
  it { should have_many(:items).inverse_of(:restaurant)}

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it { is_expected.to callback(:create_image_dir).after(:create) }
  it { is_expected.to callback(:update_image_dir).after(:save) }

  describe '#items_mapped_by_type' do
    let(:restaurant) { FactoryGirl.create(:restaurant) }
    let(:item_type) { FactoryGirl.create(:item_type) }
    let(:another_item_type) { FactoryGirl.create(:item_type) }
    let(:item) { FactoryGirl.create(:item, restaurant: restaurant, item_type_id: item_type.id) }

    before do
      item
      another_item_type
    end

    context 'called with no parameter' do
      it 'returns hash with items mapped to their type, for all existing types' do
        actual = restaurant.items_mapped_by_type

        expect(actual[item_type]).to include item
        expect(actual[another_item_type]).to eq []
      end
    end

    context 'called with a item_type list argument' do
      it 'returns hash with items mapped to the item types in the argument' do
        actual = restaurant.items_mapped_by_type([item_type])

        expect(actual[item_type]).to include item
        expect(actual[another_item_type]).to eq nil
      end
    end
  end

  describe 'image directory callbacks' do
    let(:name) { 'Some Name' }
    let(:new_name) { 'Another Name' }
    let(:restaurant) { Restaurant.create(name: name) }

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

  describe '#items_by_type' do
    let(:restaurant) { FactoryGirl.create(:restaurant) }
    let(:item_type) { FactoryGirl.create(:item_type) }

    context 'has items associated to the type' do

      it 'returns a list including the items' do
        item = FactoryGirl.create(:item, restaurant: restaurant, item_type_id: item_type.id)

        actual = restaurant.items_by_type(item_type)

        expect(actual).to include item
      end
    end

    context 'has no items associated to the type' do
      it 'returns an empty list' do
        actual = restaurant.items_by_type(item_type)

        expect(actual.empty?).to eq true
      end
    end
  end

  # describe '#image_path' do
  #   let(:item) { FactoryGirl.build_stubbed(:item, name: 'Some Item') }
  #   let(:restaurant_path_name) { 'some_restaurant' }
  #   it 'returns the image path' do
  #     allow(item).to receive(:restaurant_path_name) { '' }
  #     path_name = 'app/assets/images/restaurants/some_restaurant/items/some_item.jpeg'

  #     allow(Dir).to receive(:[]) { [path_name] }

  #     path = item.image_path

  #     expect(path).to eq 'restaurants/some_restaurant/items/some_item.jpeg'
  #   end
  # end
end
