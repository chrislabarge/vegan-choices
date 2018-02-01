require 'rails_helper'

feature 'User:CreatesRestaurant ', js: true do
  scenario 'a user creates a restaurant with items' do
    mock_geocoding!
    mock_google_places

    ItemType.create(name: 'beverage')
    user = FactoryBot.create(:user)
    FactoryBot.create(:restaurant)
    restaurant = FactoryBot.build(:restaurant)
    location = build(:location)
    item = build(:item)
    item_photo = build(:item_photo, item: item)
    location_count = Location.count

    authenticate(user)

    visit new_restaurant_path

    fill_form(restaurant, location, item, item_photo)

    submit_restaurant

    expect(page).to have_text('Successfully created the restaurant.')
    expect(page).to have_text('Thank you for contributing!')
    expect(Restaurant.last.user).to eq user
    expect(find('h1').text).to eq restaurant.name
    expect(Restaurant.last.items.present?).to eq true
    expect(Restaurant.last.items.last.user).to eq user
    expect(Restaurant.last.locations.present?).to eq true
    expect(Location.count).to eq(location_count + 1)

    drop_accordian

    expect(all('.restaurant-items').first).to have_content(item.name.upcase) || have_content(item.name)

    expect_photos_have_uploaded(item_photo)
  end

  scenario 'a user tries to create a duplicate restaurant name' do
    mock_geocoding!
    mock_google_places

    FactoryBot.create(:item_type, name: 'beverage')
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant)
    location = build(:location)
    item = build(:item)

    location_count = Location.count

    authenticate(user)

    #TODO: this is getting screwed up because of the distance index
    visit new_restaurant_path
    # visit restaurants_path(sort_by: 'contant_berries')

    fill_form(restaurant, location, item)

    submit_restaurant

    expect(page).to have_text('Unable to create the restaurant.')
    expect(page).to have_text('Name has already been taken')
    expect(Location.count).to eq(location_count)
  end

  scenario 'a visitor tries to add an restaurant' do
    mock_geocoding!
    FactoryBot.create(:item)

    #TODO: this is getting screwed up because of the distance index
    visit new_restaurant_path
    # visit restaurants_path(sort_by: 'contant_berries')

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end

  def drop_accordian
    all('.food-items .dropdown.icon').first.trigger('click')
    sleep(1)
  end
end
