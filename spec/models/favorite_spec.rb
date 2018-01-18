require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it { should belong_to(:item).inverse_of(:favorites) }
  it { should belong_to(:user).inverse_of(:favorites) }
  it { should belong_to(:restaurant).inverse_of(:favorites) }
  it { should belong_to(:profile).class_name('User').with_foreign_key(:profile_id) }

  it { should validate_presence_of(:user_id) }

  describe 'Uniqueness Validation' do

    it 'does not allow multiple favorites for the same restaurant and user' do
      restaurant = FactoryBot.create(:restaurant)
      favorite = FactoryBot.create(:favorite, restaurant: restaurant)
      another_favorite = FactoryBot.build(:favorite, user: favorite.user,
      restaurant: favorite.restaurant)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).not_to eq true
    end

    it 'allows for multiple restaurant favorites for user' do
      restaurant = FactoryBot.create(:restaurant)
      favorite = FactoryBot.create(:favorite, restaurant: restaurant)
      new_restaurant = FactoryBot.create(:restaurant)
      another_favorite = FactoryBot.build(:favorite, user: favorite.user,
      restaurant: new_restaurant)

      another_favorite.save
      actual = another_favorite.persisted?


      expect(actual).to eq true
    end

    it 'does not allow multiple favorites for the same item and user' do
      item = FactoryBot.create(:item)
      favorite = FactoryBot.create(:favorite, item: item)
      another_favorite = FactoryBot.build(:favorite, user: favorite.user,
                                                      item: favorite.item)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).not_to eq true
    end

    it 'allows for multiple item favorites for user' do
      item = FactoryBot.create(:item)
      favorite = FactoryBot.create(:favorite, item: item)
      new_item = FactoryBot.create(:item)
      another_favorite = FactoryBot.build(:favorite, user: favorite.user,
      item: new_item)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).to eq true
    end

    it 'does not allow multiple favorites for the same user and profile' do
      user = FactoryBot.create(:user)
      favorite = FactoryBot.create(:favorite, profile: user)
      follower = favorite.user

      another_favorite = FactoryBot.build(:favorite, user: follower,
      profile: user)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).not_to eq true
    end

    it 'allows for multiple user/profile favorites for user' do
      user = FactoryBot.create(:user)
      another_user = FactoryBot.create(:user)
      favorite = FactoryBot.create(:favorite, profile: user)
      new_item = FactoryBot.create(:item)
      another_favorite = FactoryBot.build(:favorite, user: favorite.user, profile: another_user)

      another_favorite.save

      actual = another_favorite.persisted?

      expect(actual).to eq true
    end
  end
end
