module RestaurantHelper
  def fill_form(restaurant, location, item)
    fill_in 'searchPlaces', with: restaurant.name
    fill_in 'Website', with: restaurant.website
    fill_location_form(location)
    click_link 'Add Vegan Option'
    fill_item_form(item)
  end

  def fill_item_form(item)
    within '.nested-fields' do
      fill_in 'Name', with: item.name
      select_type
      fill_in 'Description', with: item.description
      fill_in 'Instructions', with: item.instructions
    end
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

  def submit_restaurant
    click_button 'Add Restaurant'
  end
end
