require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'Uniqueness Validation' do
    let(:favorite) { FactoryGirl.create(:favorite) }

    it 'does not allow multiple favorites for the same restaurant and user' do
      another_favorite = FactoryGirl.build(:favorite, user: favorite.user,
                                              restaurant: favorite.restaurant)

      another_favorite.save
      actual = another_favorite.persisted?

      expect(actual).not_to eq true
    end
  end
end
