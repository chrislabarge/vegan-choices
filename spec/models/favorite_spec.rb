require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it { should belong_to(:item).inverse_of(:favorites) }
  it { should belong_to(:user).inverse_of(:favorites) }
  it { should belong_to(:restaurant).inverse_of(:favorites) }

  it { should validate_presence_of(:user_id) }

  describe 'Uniqueness Validation' do

    it 'does not allow multiple favorites for the same restaurant and user' do
      restaurant = FactoryGirl.create(:restaurant)
      favorite = FactoryGirl.create(:favorite, restaurant: restaurant)
      another_favorite = FactoryGirl.build(:favorite, user: favorite.user,
      restaurant: favorite.restaurant)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).not_to eq true
    end

    it 'allows for multiple restaurant favorites for user' do
      restaurant = FactoryGirl.create(:restaurant)
      favorite = FactoryGirl.create(:favorite, restaurant: restaurant)
      new_restaurant = FactoryGirl.create(:restaurant)
      another_favorite = FactoryGirl.build(:favorite, user: favorite.user,
      restaurant: new_restaurant)

      another_favorite.save
      actual = another_favorite.persisted?


      expect(actual).to eq true
    end

    it 'does not allow multiple favorites for the same item and user' do
      item = FactoryGirl.create(:item)
      favorite = FactoryGirl.create(:favorite, item: item)
      another_favorite = FactoryGirl.build(:favorite, user: favorite.user,
                                                      item: favorite.item)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).not_to eq true
    end

    it 'allows for multiple item favorites for user' do
      item = FactoryGirl.create(:item)
      favorite = FactoryGirl.create(:favorite, item: item)
      new_item = FactoryGirl.create(:item)
      another_favorite = FactoryGirl.build(:favorite, user: favorite.user,
      item: new_item)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).to eq true
    end
  end
end
