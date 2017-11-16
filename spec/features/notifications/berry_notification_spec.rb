require 'rails_helper'
include CommentsHelper

feature 'Notficiations: Content Berries', js: true do
  scenario 'a user gives a berry to another users restaurant comment' do
    restaurant_comment = FactoryGirl.create(:restaurant_comment)
    comment = restaurant_comment.comment
    creator = comment.user
    FactoryGirl.create(:content_berry, comment: comment)

    authenticate(creator)

    expect_notification_content

    click_link('View')

    expect(page).not_to have_text('New Berry')
    expect(page).to have_text(restaurant_comment.content)
  end

  scenario 'a user gives a berry to another users item comment' do
    item_comment = FactoryGirl.create(:item_comment)
    comment = item_comment.comment
    creator = comment.user
    FactoryGirl.create(:content_berry, comment: comment)

    authenticate(creator)

    expect_notification_content

    click_link('View')

    expect(page).not_to have_text('New Berry')
    expect(page).to have_text(item_comment.content)
  end

  scenario 'a user gives a berry to another users reply comment' do
    item_comment = FactoryGirl.create(:item_comment)
    reply_comment = FactoryGirl.create(:reply_comment, reply_to: item_comment.comment)
    comment = reply_comment.comment
    creator = comment.user
    FactoryGirl.create(:content_berry, comment: comment)
    item = item_comment.item

    authenticate(creator)

    expect_notification_content

    click_link('View')

    expect(page).not_to have_text('New Berry')
    expect(page).to have_text(reply_comment.content)
  end

  scenario 'a user gives a berry to another users deeply nested reply comment' do
    restaurant_comment = FactoryGirl.create(:restaurant_comment)
    reply_comment = FactoryGirl.create(:reply_comment, reply_to: restaurant_comment.comment)
    nested_reply_comment = FactoryGirl.create(:reply_comment, reply_to: reply_comment.comment)
    comment = nested_reply_comment.comment
    creator = comment.user
    FactoryGirl.create(:content_berry, comment: comment)

    authenticate(creator)

    expect_notification_content

    click_link('View')

    expect(page).not_to have_text('New Berry')
    expect(page).to have_text(nested_reply_comment.content)
  end


  scenario 'a user gives a berry to another users item' do
    creator = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, user: creator)
    FactoryGirl.create(:content_berry, item: item)

    authenticate(creator)

    expect_notification_content

    click_link('View')

    expect(page).not_to have_text('New Berry')
    expect(page).to have_text(item.name)
  end

  scenario 'a user gives a berry to another users restaurant' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:content_berry, restaurant: restaurant)

    authenticate(creator)

    expect_notification_content

    click_link('View')

    expect(page).not_to have_text('New Berry')
    expect(page).to have_text(restaurant.name)
  end

  def expect_notification_content
    expect(page).to have_text("New Notification 1")
    find('.notifications i.icon').click
    expect(page).to have_text("New Berry")
  end
end
