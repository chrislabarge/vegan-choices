require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it { should have_many(:ingredient_lists).inverse_of(:restaurant)}
  it { should have_many(:items).inverse_of(:restaurant)}

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

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
end
