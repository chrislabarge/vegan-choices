require 'rails_helper'

feature 'Favorites:FavoriteRestaurant', js: true do
  scenario 'a user favorites a restaurant' do
    restaurant = FactoryBot.create(:restaurant)
    user = FactoryBot.create(:user)

    authenticate(user)

    visit restaurant_path(restaurant)

    add_to_favorites

    expect(page).to have_text('You have added the restaurant to your favorites.')
    expect(user.favorite_restaurants).to include restaurant
  end

  scenario 'a restaurant can be unfavorited' do
    restaurant = FactoryBot.create(:restaurant)
    favorite = FactoryBot.create(:favorite, restaurant: restaurant)
    user = favorite.user

    authenticate user

    visit restaurant_path(restaurant)

    find('.favorite .remove').click()

    expect(page).to have_text("Successfully removed the restaurant from your favorites")
  end

  scenario 'a visitor cannot add a restaurant to favorites' do
    #TODO: these are just like all of the other commented out specs if favorite features.  The web driver is not displaying the proper error message.

    # restaurant = FactoryBot.create(:restaurant)

    # visit restaurant_path(restaurant)

    # add_to_favorites

    # expect(page).to have_text("Please Sign In")
    # expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def add_to_favorites
  find('.favorite .submit').trigger 'click'
end
