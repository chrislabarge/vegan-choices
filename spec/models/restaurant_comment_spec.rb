require 'rails_helper'

RSpec.describe RestaurantComment, type: :model do
  it { should belong_to(:restaurant).inverse_of(:restaurant_comments) }
  it { should belong_to(:comment).inverse_of(:restaurant_comment) }

  it { should have_one(:user).through(:comment) }

  describe 'dependent on user' do
    let(:restaurant_comment) { FactoryGirl.create(:restaurant_comment) }

    it 'destroys self when user is destroyed' do
      user = restaurant_comment.user
      restaurant_comment_count = RestaurantComment.all.count

      user.destroy

      actual = RestaurantComment.all.count

      expected = restaurant_comment_count - 1

      expect(actual).to eq expected
    end
  end
end
