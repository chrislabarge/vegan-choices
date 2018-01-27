require 'rails_helper'

Capybara.ignore_hidden_elements = false

feature 'Auto Results Search: Restaurants' do
  #these are no longer gitting the search DB, i will have to debug
  pending 'Search for existing Restaurant by name', js: true do
    item = FactoryBot.create(:item)
    restaurant = item.restaurant

    given_a_visitor_is_viewing_any_page

    when_they_search_for_a(restaurant)

    sleep(1)

    they_should_be_shown_results_containing_the(restaurant)
  end

  #these are no longer gitting the search DB, i will have to debug
  pending 'Search for non-existing Restaurant by name', js: true do
    non_existant_restaurant = FactoryBot.build(:restaurant)

    given_a_visitor_is_viewing_any_page

    when_they_search_for_a(non_existant_restaurant)

    sleep(1)

    they_should_be_shown_no_results_message
  end
end

feature 'Submitted Form Search Results: Restaurants' do
  scenario 'Search for existing Restaurant by name', js: true do
    restaurant = FactoryBot.create(:restaurant)

    given_a_visitor_is_viewing_any_page

    when_they_search_for_a(restaurant)
    submit_search_form

    sleep(1)

    they_should_be_shown_result_list_containing_the(restaurant)
  end

  scenario 'Search for non-existing Restaurant by name', js: true do
    non_existing_restaurant = FactoryBot.build(:restaurant, name: 'name')

    given_a_visitor_is_viewing_any_page

    when_they_search_for_a non_existing_restaurant
    submit_search_form

    sleep(1)

    they_should_be_redirected_to_the_restaurant_index
    they_should_see_no_results_notfication(non_existing_restaurant)
  end
end

def given_a_visitor_is_viewing_any_page
  visit root_path
end

def when_they_search_for_a(object)
  name = object.name
  search_by(name)
end

def search_by(string)
  fill_in('searchHero', with: string)
  sleep(1)
end

def they_should_be_shown_results_containing_the(restaurant)
  expect(page).to have_css('.results')
  expect_restaurant_result(restaurant)
end

def they_should_be_shown_no_results_message
  results = nil

  within(:css, ".masthead") do
    results = find(:css, '.results')
  end

  within(results) do
    no_results_message = 'Your search returned no results'

    expect(page).to have_text(no_results_message)
  end
end

def they_should_be_shown_result_list_containing_the(restaurant)
  name = restaurant.name
  expect_search_results_page_content(name)

  expect(page).to have_content(name)
end

def expect_search_results_page_content(search_term)
  within(:css, shared_header_css) do
    header_text = find(:css, 'h1').text
    sub_header_text = find(:css, 'h2').text
    expect(header_text).to eq('Restaurant Search Results')
    expect(sub_header_text).to eq "(for term: '#{search_term}')"
  end
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
  items_count = restaurant.items.count
  expect(page).to have_content("#{items_count} Items")
end

def submit_search_form
  within(:css, ".masthead") do
    find(:css, "input[type='submit']").trigger('click')
  end
end

def they_should_be_redirected_to_the_restaurant_index
  within(:css, shared_header_css) do
    header_text = find(:css, 'h1').text
    expect(header_text).to eq('Restaurants')
  end
end

def shared_header_css
  '.page-header'
end

def they_should_see_no_results_notfication(restaurant)
  name = restaurant.name
  notification = "Unable to find any restaurants that match the search term '#{name}'"

  expect(page).to have_content(notification)
end
