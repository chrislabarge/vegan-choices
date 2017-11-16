require 'rails_helper'

RSpec.describe ContentBerry, type: :model do
  it { should belong_to(:user).inverse_of(:content_berries) }
  it { should belong_to(:restaurant).inverse_of(:content_berries) }
  it { should belong_to(:item).inverse_of(:content_berries) }
  it { should belong_to(:comment).inverse_of(:content_berries) }

  # describe 'update_' do
  #   it 'does not allow multiple favorites for the same restaurant and user' do
  #     restaurant = FactoryGirl.create(:restaurant)
  #     favorite = FactoryGirl.create(:favorite, restaurant: restaurant)
  #     another_favorite = FactoryGirl.build(:favorite, user: favorite.user,
  #     restaurant: favorite.restaurant)

  #     another_favorite.save
  #     actual = another_favorite.persisted?

  #     expect(actual).not_to eq true
  #   end
  # end
end
