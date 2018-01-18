require 'rails_helper'

RSpec.describe ItemComment, type: :model do
  it { should belong_to(:item).inverse_of(:item_comments) }
  it { should belong_to(:comment) }
  it { should have_one(:user).through(:comment) }

  it { should validate_presence_of(:comment) }
  it { should validate_presence_of(:item) }

  describe 'dependent on comment' do
    let(:item_comment) { FactoryBot.create(:item_comment) }

    it 'destroys self when comment is destroyed' do
      comment = item_comment.comment
      item_comment_count = ItemComment.all.count

      comment.destroy

      actual = ItemComment.all.count

      expected = item_comment_count - 1

      expect(actual).to eq expected
    end
  end

  describe 'dependent on user' do
    let(:item_comment) { FactoryBot.create(:item_comment) }

    it 'destroys self when user is destroyed' do
      user = item_comment.user
      item_comment_count = ItemComment.all.count

      user.destroy

      actual = ItemComment.all.count

      expected = item_comment_count - 1

      expect(actual).to eq expected
    end
  end
end
