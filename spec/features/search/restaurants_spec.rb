require 'rails_helper'

Capybara.ignore_hidden_elements = false

feature 'Auto Results Search: Restaurants' do
  scenario 'Search for Restaurants by name', js: true do
    restaurant = FactoryGirl.create(:restaurant)

    given_a_vistor_is_viewing_any_page

    when_they_search_for_a(restaurant)

    sleep(1)

    they_should_be_shown_results_containing_the(restaurant)
  end

  def given_a_vistor_is_viewing_any_page
    visit about_path
  end

  def when_they_search_for_a(object)
    name = object.name
    search_by_first_character(name)
  end

  def search_by_first_character(string)
    first_character = string[0]
    fill_in('search', with: first_character)
  end

  def they_should_be_shown_results_containing_the(restaurant)
    expect(page).to have_css('.results')
    expect_restaurant_result(restaurant)
  end

  def expect_restaurant_result(restaurant)
    name = restaurant.name
    path = restaurant_path(restaurant)

    within(:css, "a[href$='#{path}']") do
      expect(page).to have_content(name)
      expect_item_count_display(restaurant)
    end
  end

  def expect_item_count_display(restaurant)
    menu_items_count = restaurant.menu_items.count
    other_items_count = restaurant.non_menu_items.count

    expect(page).to have_content("Menu Items: #{menu_items_count}")
    expect(page).to have_content("Other Items: #{other_items_count}")
  end
end
