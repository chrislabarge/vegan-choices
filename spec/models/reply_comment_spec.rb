require 'rails_helper'

RSpec.describe ReplyComment, type: :model do
  it { should belong_to(:comment) }
  it { should belong_to(:reply_to).class_name('Comment').with_foreign_key(:reply_to_id)  }

  it { should validate_presence_of(:comment) }
  it { should validate_presence_of(:reply_to) }

  describe '#reply_to' do
    let(:comment) { FactoryBot.create(:comment) }
    let(:comment_in_reply_to) { FactoryBot.create(:comment) }
    let(:reply_comment) { ReplyComment.create(comment: comment, reply_to: comment_in_reply_to) }

    it 'returns the comment being replied to' do
      expected = comment_in_reply_to

      actual = reply_comment.reply_to

      expect(actual).to eq expected
    end
  end

  describe 'dependent on comment' do
    let(:reply_comment) { FactoryBot.create(:reply_comment) }

    it 'destroys self when comment is destroyed' do
      comment = reply_comment.comment
      reply_comment_count = ReplyComment.all.count

      comment.destroy

      actual = ReplyComment.all.count

      expected = reply_comment_count - 1

      expect(actual).to eq expected
    end
  end

  describe 'dependent on reply_to' do
    let(:reply_comment) { FactoryBot.create(:reply_comment) }

    it 'destroys self when comment is destroyed' do
      comment = reply_comment.reply_to
      reply_comment_count = ReplyComment.all.count

      comment.destroy

      actual = ReplyComment.all.count

      expected = reply_comment_count - 1

      expect(actual).to eq expected
    end
  end

  describe 'dependent on user' do
    let(:reply_comment) { FactoryBot.create(:reply_comment) }

    it 'destroys self when user is destroyed' do
      user = reply_comment.user
      reply_comment_count = ReplyComment.all.count

      user.destroy

      actual = ReplyComment.all.count

      expected = reply_comment_count - 1

      expect(actual).to eq expected
    end
  end
end
