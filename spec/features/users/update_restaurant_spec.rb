require 'rails_helper'

feature 'User: Updates Restaurant ', js: true do
  scenario 'a user updates a restaurant' do
    mock_google_places

    ItemType.create(name: 'beverage')
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: user)
    create(:location, restaurant: restaurant)
    new_restaurant_content = FactoryBot.build(:restaurant)
    new_location_content = build(:location)
    item = FactoryBot.build(:item, restaurant: nil, ingredient_string: nil, allergen_string: nil)
    location_count = Location.count

    mock_geocoding!(mock_data(new_location_content))

    authenticate(user)

    visit restaurant_path(restaurant)

    click_edit_icon

    fill_form(new_restaurant_content, new_location_content, item)

    click_button 'Update Restaurant'

    restaurant.reload

    expect(page).to have_text('Successfully updated the restaurant.')
    expect(page).to have_text('Thank you for contributing!')
    expect(restaurant.attributes).to include new_restaurant_content.attributes.compact
    expect(restaurant.location.attributes).to include new_location_content.attributes.compact
    expect(restaurant.items.last.attributes).to include item.attributes.compact
  end

  scenario 'a user tries to update name to a duplicate item name' do
    mock_geocoding!
    mock_google_places
    ItemType.create(name: 'beverage')
    user = FactoryBot.create(:user)
    existing_restaurant = FactoryBot.create(:restaurant)
    restaurant = FactoryBot.create(:restaurant, user: user)
    create(:location, restaurant: restaurant)
    new_location = build(:location)
    item = FactoryBot.build(:item)
    location_count = Location.count
    item_count = Item.count

    authenticate(user)

    visit restaurant_path(restaurant)

    click_edit_icon

    fill_form(existing_restaurant, new_location, item)

    click_button 'Update Restaurant'

    expect(page).to have_text('Unable to update the restaurant.')
    expect(page).to have_text('Name has already been taken')
    expect(Location.count).to eq location_count
    expect(Item.count).to eq item_count
  end

  scenario 'a visitor cannot edit a restaurant' do
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: user)

    visit restaurant_path(restaurant)

    expect(page).not_to have_link("Edit")

    visit edit_restaurant_path(restaurant)

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end

  scenario 'a user cannot edit another users item' do
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: user)
    new_user = FactoryBot.create(:user)

    authenticate(new_user)

    visit edit_restaurant_path(restaurant)

    expect(page).to have_text("You do not have permission to view this page.")
  end
end

def click_edit_icon
  find('.edit-item i').trigger('click')
end
