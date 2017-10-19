require 'rails_helper'

feature 'User:Show Page', js: true do
  scenario 'a user\'s favorite restaurants are displayed on their show page' do
    restaurant = FactoryGirl.create(:restaurant)
    favorite = FactoryGirl.create(:favorite, restaurant: restaurant)

    user = favorite.user

    authenticate(user)

    expect(page).to have_text('Favorite Restaurants')
    expect(page).to have_text(restaurant.name)
  end
end

