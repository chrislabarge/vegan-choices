require 'rails_helper'
include CommentsHelper

feature 'Notficiations: Item Created', js: true do
  scenario 'a user adds an item to a user-restaurant' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    item = FactoryGirl.create(:item, restaurant: restaurant)

    authenticate(creator)

    actual = get_notification_text

    expect(actual).to eq("1")

    find('.notifications i.icon').click

    expect(page).to have_text("New Item")

    click_link('View')

    expect(page).not_to have_text('New Item')
    expect(page).to have_text(item.name.titleize)
  end

  scenario 'a user adds an item to a favorited restaurant' do
    restaurant = FactoryGirl.create(:restaurant)
    2.times { FactoryGirl.create(:favorite, restaurant: restaurant) }
    item = FactoryGirl.create(:item, restaurant: restaurant)
    user_1 = Favorite.first.user
    user_2 = Favorite.last.user

    [user_1, user_2].each do |favoritor|

      visit root_path

      authenticate(favoritor)

      actual = get_notification_text

      expect(actual).to eq("1")

      find('.notifications i.icon').click

      expect(page).to have_text("New Item")

      click_link('View')

      expect(page).not_to have_text('New Item')
      expect(page).to have_text(item.name.titleize)

      sign_out

      sleep(1)
    end
  end

  scenario 'upon adding an item: restaurant creator does NOT receive duplicate notifications' do
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    FactoryGirl.create(:favorite, restaurant: restaurant, user: creator)
    FactoryGirl.create(:item, restaurant: restaurant)

    authenticate(creator)

    actual = get_notification_text

    expect(actual).to eq("1")

    find('.notifications i.icon').click

    expect(page).to have_text("New Item")
    expect(page).not_to have_text("favorite")
  end
end
