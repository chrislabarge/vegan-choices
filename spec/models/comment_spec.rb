require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:user).inverse_of(:comments) }
  it { should have_one(:item_comment).inverse_of(:comment).dependent(:destroy) }
  it { should have_one(:restaurant_comment).inverse_of(:comment).dependent(:destroy) }
  it { should have_one(:reply_comment).dependent(:destroy) }
  it { should have_many(:reply_comments).with_foreign_key(:reply_to_id) }
  it { should have_many(:content_berries).inverse_of(:comment).dependent(:destroy) }

  it { should have_many(:comments).through(:reply_comments).source(:comment) }

  describe '#comments' do
    let(:reply) { FactoryGirl.create(:comment) }
    let(:comment_in_reply_to) { FactoryGirl.create(:comment) }

    it 'returns the comment replys' do
      FactoryGirl.create(:reply_comment, comment: reply,
                                         reply_to: comment_in_reply_to)

      actual = comment_in_reply_to.comments

      expect(actual).to include reply
    end

    it 'returns an empty array' do
      actual = comment_in_reply_to.comments

      expect(actual).not_to include reply
      expect(actual.empty?).to eq true
    end
  end
end
