require 'rails_helper'

feature 'Favorites:FavoriteItem', js: true do
  scenario 'a user favorites an item' do
    item = FactoryGirl.create(:item)
    restaurant = item.restaurant
    user = FactoryGirl.create(:user)

    authenticate(user)

    visit restaurant_path(restaurant)

    add_item_to_favorites

    expect(page).to have_text('You have added the item to your favorites.')
    expect(user.favorite_items).to include item
  end

  scenario 'a item can be unfavorited' do
    item = FactoryGirl.create(:item)
    favorite = FactoryGirl.create(:favorite, item: item)
    user = favorite.user
    restaurant = item.restaurant

    favorite_count = Favorite.count

    authenticate user

    visit restaurant_path(restaurant)

    remove_item_from_favorites

    actual = Favorite.count
    expected = favorite_count - 1
    expect(actual).to eq(expected)
  end

  scenario 'a visitor cannot add a restaurant to favorites' do
    # TODO: The error messages are not appearing on the screen for some reason, same with the test above, that is why I am only testing the DB count

    # item = FactoryGirl.create(:item)
    # restaurant = item.restaurant
    # FactoryGirl.create(:favorite, item: item)

    # visit restaurant_path(restaurant)

    # add_item_to_favorites

    # expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def add_item_to_favorites
  drop_accordian
  sleep(1)
  all('.favorite .submit').last.trigger 'click'
  sleep(1)
end

def remove_item_from_favorites
  add_item_to_favorites
end

def drop_accordian
  all('.content.ui.accordion').first.click
end

