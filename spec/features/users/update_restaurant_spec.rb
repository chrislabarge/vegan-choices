require 'rails_helper'

feature 'User: Updates Restaurant ', js: true do
  scenario 'a user updates a restaurants' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: user)
    new_restaurant_content = FactoryGirl.build(:restaurant)

    authenticate(user)

    visit restaurant_path(restaurant)

    click_link 'Edit'

    fill_form(new_restaurant_content)

    click_button 'Update Restaurant'

    restaurant.reload

    expect(page).to have_text('Successfully updated the restaurant.')
    expect(page).to have_text('Thank you for contributing!')
    expect(restaurant.name).to eq new_restaurant_content.name
    expect(restaurant.website).to eq new_restaurant_content.website
  end

  scenario 'a user tries to update name to a duplicate item name' do
    user = FactoryGirl.create(:user)
    existing_restaurant = FactoryGirl.create(:restaurant)
    restaurant = FactoryGirl.create(:restaurant, user: user)

    authenticate(user)

    visit restaurant_path(restaurant)

    click_link 'Edit'

    fill_form(existing_restaurant)

    click_button 'Update Restaurant'

    expect(page).to have_text('Unable to update the restaurant.')
    expect(page).to have_text('Name has already been taken')
  end

  scenario 'a visitor cannot edit a restaurant' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: user)

    visit restaurant_path(restaurant)

    expect(page).not_to have_link("Edit")

    visit edit_restaurant_path(restaurant)

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end

  scenario 'a user cannot edit another users item' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: user)
    new_user = FactoryGirl.create(:user)

    authenticate(new_user)

    visit edit_restaurant_path(restaurant)

    expect(page).to have_text("You do not have permission to view this page.")
  end
end

def fill_form(restaurant)
  fill_in 'Restaurant Name', with: restaurant.name
  fill_in 'Website', with: restaurant.website
end
