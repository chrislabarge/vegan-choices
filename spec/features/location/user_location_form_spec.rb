require 'rails_helper'

feature 'User:Location Form ', js: true do
  scenario 'a user location is already filled out upon signing in for the first time' do
    mock_geocoding! mock_data
    user = FactoryBot.create(:user, name: nil)

    username = "Phil"

    authenticate(user)

    expect(page).to have_text('Please create a profile')

    expect(find_field('Country').value).to eq mock_data["country_name"]
    expect(find_field('State').value).to eq mock_data["region_name"]
    expect(find_field('City').value).to eq mock_data["city"]

    fill_in 'Username', with: username
    click_button 'Submit'

    expect(page).to have_text('Successfully created a profile')
  end

  scenario 'a new restaurants location already has country and state/region filled out' do
    mock_geocoding!

    ItemType.create(name: 'beverage')
    user = FactoryBot.create(:user)
    location = create(:location, user: user)
    restaurant = FactoryBot.build(:restaurant)
    location_count = Location.count

    authenticate(user)

    visit new_restaurant_path()

    expect(find_field('Country').value).to eq location.country
    expect(find_field('State').value).to eq location.state

    fill_form(restaurant)

    click_button 'Create Restaurant'

    expect(page).to have_text('Successfully created the restaurant.')
    expect(page).to have_text('Thank you for contributing!')
    expect(Restaurant.last.user).to eq user
    expect(find('h1').text).to eq restaurant.name
    expect(Restaurant.last.locations.present?).to eq true
    expect(Location.count).to eq(location_count + 1)
  end

  def fill_form(restaurant)
    fill_in 'Name', with: restaurant.name
    fill_in 'Website', with: restaurant.website
    fill_in 'City', with: 'Albany'
  end
end
