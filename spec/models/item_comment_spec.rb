require 'rails_helper'

RSpec.describe ItemComment, type: :model do
  it { should belong_to(:item).inverse_of(:item_comments) }
  it { should belong_to(:comment) }
  it { should have_one(:user).through(:comment) }

  it { should validate_presence_of(:comment) }
  it { should validate_presence_of(:item) }

  describe 'dependent on comment' do
    let(:item_comment) { FactoryGirl.create(:item_comment) }

    it 'destroys self when comment is destroyed' do
      comment = item_comment.comment
      item_comment_count = ItemComment.all.count

      comment.destroy

      actual = ItemComment.all.count

      expected = item_comment_count - 1

      expect(actual).to eq expected
    end
  end
end
