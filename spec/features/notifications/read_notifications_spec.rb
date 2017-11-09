require 'rails_helper'

feature 'Notficiations: Viewed', js: true do
  scenario 'a notificaton gets received by the user' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:restaurant_comment, restaurant: restaurant)

    authenticate(creator)

    expect(page).to have_text("New Notification 1")
    find('.notifications i.icon').click

    within('.footer') { click_link 'Profile' }

    expect(Notification.last.received).to eq true
    expect(page).not_to have_text("New Notification 1")
    expect(page).to have_text("Notifications")
  end

  scenario 'a new notifications gets removed by the user' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:restaurant_comment, restaurant: restaurant)

    authenticate(creator)

    expect(page).to have_text("New Notification 1")
    find('.notifications i.icon').click

    find('.submit').click

    expect(page).to have_text("Successfully removed the notification")
    expect(page).not_to have_text("New Notification 1")
  end

  scenario 'when the last notification is remotely removed from the list' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:restaurant_comment, restaurant: restaurant)

    authenticate(creator)

    expect(page).to have_text("New Notification 1")
    find('.notifications i.icon').click

    find('.submit').click

    expect(page).to have_text("Successfully removed the notification")
    expect(page).not_to have_text("New Notification 1")
    expect(page).not_to have_text("No Notifications")
  end
end
