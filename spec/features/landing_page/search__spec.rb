require 'rails_helper'

feature 'Search: Landing Page' do
  # Multiple scenarios in this page. The first one can be split up into 2.  'Show results', 'Matches Result'
  # No Matches, Matches Result could include tests for 1 character and full name, and show that the match is the first Child of the dropdown parent
  scenario 'Types one character in Search', js: true do
    restaurant = FactoryGirl.create(:restaurant)
    name = restaurant.name
    search_query = name[0]

    given_a_vistor_is_viewing_the_landing_page
    when_they_fill_the_search_bar_with(search_query)
    they_should_be_shown_the_restaurant_dropdown
    and_the_dropdown_should_include_the(name)
  end

  scenario "Clicks/Focus's the search input", js: true do
    restaurant = FactoryGirl.create(:restaurant)
    name = restaurant.name

    given_a_vistor_is_viewing_the_landing_page
    when_they_focus_on_the_input
    they_should_be_shown_the_restaurant_dropdown
    and_the_dropdown_should_include_the(name)
  end

  private

  def given_a_vistor_is_viewing_the_landing_page
    visit '/'
  end

  def when_they_fill_the_search_bar_with(value)
    fill_in('restaurant_name', with: value)
  end

  def when_they_focus_on_the_input
    # TODO: try by doing just the name instead of the ID
    find('#restaurantSearch').click
  end

  def they_should_be_shown_the_restaurant_dropdown
    expect(page).to have_css('.typeahead.dropdown-menu')
  end

  def and_the_dropdown_should_include_the(value)
    # TODO: change this name to and the dropdown should include, So i it makes sense using it above
    within('.typeahead.dropdown-menu') do
      expect(page).to have_content(value)
    end
  end
end
