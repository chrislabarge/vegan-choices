require 'rails_helper'

feature 'Notficiations: Viewed', js: true do
  scenario 'a notificaton gets received by the user' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:restaurant_comment, restaurant: restaurant)

    authenticate(creator)

    actual = get_notification_text()

    expect(actual).to eq("1")

    find('.notifications i.icon').click

    visit user_path creator

    expect(Notification.last.received).to eq true

    expect(page).not_to have_css(notification_count_label)
    expect(page).to have_css(".notifications")
  end

  scenario 'a new notifications gets removed by the user' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:restaurant_comment, restaurant: restaurant)

    authenticate(creator)

    actual = get_notification_text

    expect(actual).to have_text("1")

    find('.notifications i.icon').click

    find('.submit').click

    expect(page).to have_text("Successfully removed the notification")
    expect(page).not_to have_css(notification_count_label)
  end

  scenario 'when the last notification is remotely removed from the list' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:restaurant_comment, restaurant: restaurant)

    authenticate(creator)

    actual = get_notification_text

    expect(actual).to eq("1")

    find('.notifications i.icon').click

    find('.submit').click

    expect(page).to have_text("Successfully removed the notification")
    expect(page).to have_text("No Notifications")
  end
end
