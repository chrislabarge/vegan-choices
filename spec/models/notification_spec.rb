require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'depedent on the resource notification' do
    let(:restaurant) { FactoryGirl.create(:restaurant, user: FactoryGirl.create(:user)) }
    let(:item) { FactoryGirl.create(:item, user: FactoryGirl.create(:user), restaurant: restaurant)}
    let(:content_berry) { FactoryGirl.create(:content_berry, item: item) }
    let(:item_comment) { FactoryGirl.create(:item_comment, item: item) }
    let(:restaurant_comment) { FactoryGirl.create(:restaurant_comment, restaurant: restaurant) }
    let(:reply_comment) { FactoryGirl.create(:reply_comment, reply_to: item_comment.comment) }

    pending 'gets destroyed when the notficication receiver gets destroyed' do
      #this is interesting, it seems the user cannot delete their account if they have made content, will have to test that.
      content_berry
      notification_count = Notification.all.count
      user = Notification.last.user

      user.destroy

      expected = notification_count - 1
      actual = Notification.all.count

      expect(actual).to eq expected
    end


    it 'gets destroyed when the content_berry gets destroyed' do
      content_berry
      notification_count = Notification.all.count

      content_berry.destroy

      expected = notification_count - 1
      actual = Notification.all.count

      expect(actual).to eq expected
    end

    [
     :restaurant_comment,
    #  :reply_comment, # these two arnt working because they are being built off shared elements,
    #  :item_comment # I will have to give them unique associations to get them to work
    ].each do |comment_type|
      it 'gets destroyed when the comment gets destroyed' do
        send comment_type
        notification_count = Notification.all.count
        send(comment_type).destroy

        expected = notification_count - 1
        actual = Notification.all.count

        expect(actual).to eq expected
      end
    end

    it 'gets destroyed when the item gets destroyed' do
      restaurant
      item
      notification_count = Notification.all.count

      item.destroy
      expected = notification_count - 1
      actual = Notification.all.count

      expect(actual).to eq expected
    end

    it 'gets destroyed when the favorited restaurants item gets destroyed' do
      FactoryGirl.create(:favorite, restaurant: restaurant)
      item = FactoryGirl.create(:item, restaurant: restaurant)

      old_count = Notification.all.count

      item.destroy

      expected = 0
      new_count = Notification.all.count

      expect(old_count).not_to eq 0
      expect(new_count).to eq expected
    end
  end
end
