require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it { should have_many(:ingredient_lists).inverse_of(:restaurant)}
  it { should have_many(:items).inverse_of(:restaurant)}

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#items_mapped_by_type' do
    let(:restaurant) { FactoryGirl.build_stubbed(:restaurant) }
    let(:item_type) { FactoryGirl.create(:item_type) }

    context 'has items associated to the type' do

      it 'returns a list including the items' do
        item = FactoryGirl.create(:item, restaurant: restaurant, item_type_id: item_type.id)

        actual = restaurant.items_mapped_by_type(item_type)

        expect(actual).to include item
      end
    end

    context 'has no items associated to the type' do
      it 'returns an empty list' do
        actual = restaurant.items_mapped_by_type(item_type)

        expect(actual.empty?).to eq true
      end
    end
  end


  describe '#items_by_type' do
    let(:restaurant) { FactoryGirl.build_stubbed(:restaurant) }
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
