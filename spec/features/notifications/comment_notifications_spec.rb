require 'rails_helper'
include CommentsHelper

feature 'Notficiations: Comments', js: true do
  scenario 'a user comments on a user-restaurant' do
    creator = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: creator)
    restaurant_comment = FactoryBot.create(:restaurant_comment, restaurant: restaurant)

    authenticate(creator)

    actual = get_notification_text

    expect(actual).to eq("1")

    find('.notifications i.icon').click
    expect(page).to have_text("New Comment")

    click_link('View')

    expect(page).not_to have_text("New Comment")
    expect(page).to have_text(restaurant_comment.content)
  end

  scenario 'a user comments on a user-item' do
    creator = FactoryBot.create(:user)
    item = FactoryBot.create(:item, user: creator)
    item_comment = FactoryBot.create(:item_comment, item: item)

    authenticate(creator)

    actual = get_notification_text

    expect(actual).to eq("1")

    find('.notifications i.icon').click
    expect(page).to have_text("New Comment")

    click_link('View')

    expect(page).not_to have_text("New Comment")
    expect(page).to have_text(item_comment.content)
  end

  scenario 'a user replies to a user comment' do
    restaurant_comment = FactoryBot.create(:restaurant_comment)
    reply = FactoryBot.create(:reply_comment, reply_to: restaurant_comment.comment)
    creator = reply.reply_to.user

    authenticate(creator)

    actual = get_notification_text

    expect(actual).to eq("1")

    find('.notifications i.icon').click
    expect(page).to have_text("New Comment")

    click_link('View')

    expect(page).not_to have_text("New Comment")
    expect(page).to have_text(reply.content)
  end

  scenario 'a user comments on a on a favorited item' do
    item = FactoryBot.create(:item)
    2.times { FactoryBot.create(:favorite, item: item) }
    item_comment = FactoryBot.create(:item_comment, item: item)
    user_1 = Favorite.first.user
    user_2 = Favorite.last.user

    [user_1, user_2].each do |favoritor|
      authenticate(favoritor)

      actual = get_notification_text

      expect(actual).to eq("1")

      find('.notifications i.icon').click
      expect(page).to have_text("New Comment")

      click_link('View')

      expect(page).not_to have_text("New Comment")
      expect(page).to have_text(item_comment.content)

      sign_out

      sleep(1)
    end
  end
end
