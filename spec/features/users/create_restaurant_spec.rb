require 'rails_helper'

feature 'User:CreatesRestaurant ', js: true do
  scenario 'a user creates a restaurant' do
    mock_geocoding!

    ItemType.create(name: 'beverage')
    user = FactoryBot.create(:user)
    FactoryBot.create(:restaurant)
    restaurant = FactoryBot.build(:restaurant)
    location_count = Location.count

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
    expect(Restaurant.last.locations.present?).to eq true
    expect(Location.count).to eq(location_count + 1)
  end

  scenario 'a user tries to create a duplicate restaurant name' do
    mock_geocoding!

    FactoryBot.create(:item_type, name: 'beverage')
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant)
    location_count = Location.count

    authenticate(user)

    visit restaurants_path

    click_link 'Add Restaurant'

    fill_form(restaurant)

    click_button 'Create Restaurant'

    expect(page).to have_text('Unable to create the restaurant.')
    expect(page).to have_text('Name has already been taken')
    expect(Location.count).to eq(location_count)
  end

  scenario 'a visitor tries to add an restaurant' do
    FactoryBot.create(:item)

    visit restaurants_path

    click_link 'Add Restaurant'

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def fill_form(restaurant)
  fill_in 'Name', with: restaurant.name
  fill_in 'Website', with: restaurant.website
  fill_location_form(FactoryBot.build :location)
  click_link 'Add Vegan Option'
  fill_item_form(FactoryBot.build :item)
end

def fill_item_form(item)
  within '.nested-fields' do
    fill_in 'Name', with: item.name
    select_type
    fill_in 'Description', with: item.description
    fill_in 'Instructions', with: item.instructions
  end
  # TODO: Eventually allow users to add their own ingredients for the item, if they somehow have them
  #  I should give them like 2 berries for every ingredient or something, I dunno though, people might just take advantage and not give accurate information
  # fill_in 'Ingredients', with: 'An ingredient'
end


def select_type
  all('.ui.dropdown').last.click
  sleep(1)
  all('.menu.visible .item').last.click
end

def fill_location_form(location)
  fill_in 'Country', with: location.country
  fill_in 'State', with: location.state
  fill_in 'City', with: location.city
end
