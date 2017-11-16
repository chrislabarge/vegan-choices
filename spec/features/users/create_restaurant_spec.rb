require 'rails_helper'

feature 'User:CreatesRestaurant ', js: true do
  scenario 'a user creates a restaurant' do
    ItemType.create(name: 'beverage')
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:restaurant)
    restaurant = FactoryGirl.build(:restaurant)

    authenticate(user)

    visit restaurants_path

    click_link 'Add Restaurant'

    fill_form(restaurant)

    click_button 'Create Restaurant'

    expect(page).to have_text('Successfully created the restaurant.')
    expect(page).to have_text('Thank you for contributing!')
    expect(Restaurant.last.user).to eq user
    expect(find('h1').text).to eq restaurant.name
    expect(Restaurant.last.items.present?).to eq true
  end

  scenario 'a user tries to create a duplicate restaurant name' do
    FactoryGirl.create(:item_type, name: 'beverage')
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant)

    authenticate(user)

    visit restaurants_path

    click_link 'Add Restaurant'

    fill_form(restaurant)

    click_button 'Create Restaurant'

    expect(page).to have_text('Unable to create the restaurant.')
    expect(page).to have_text('Name has already been taken')
  end

  scenario 'a visitor tries to add an restaurant' do
    FactoryGirl.create(:item)

    visit restaurants_path

    click_link 'Add Restaurant'

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def fill_form(restaurant)
  fill_in 'Name', with: restaurant.name
  fill_in 'Website', with: restaurant.website
  click_link 'Add Item'
  fill_item_form(FactoryGirl.build :item)
end

def fill_item_form(item)
  fill_in 'Item Name', with: item.name
  select_type
  fill_in 'Description', with: item.description
  fill_in 'Instructions', with: item.instructions

  # TODO: Eventually allow users to add their own ingredients for the item, if they somehow have them
  #  I should give them like 2 berries for every ingredient or something, I dunno though, people might just take advantage and not give accurate information
  # fill_in 'Ingredients', with: 'An ingredient'
end


def select_type
  all('.ui.dropdown').last.click
  sleep(1)
  all('.menu.visible .item').last.click
end
