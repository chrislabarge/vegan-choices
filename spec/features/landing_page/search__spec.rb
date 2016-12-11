require 'rails_helper'

feature 'Search: Landing Page' do
  #Multiple scenarios in this page. The first one can be split up into 2.  'Show results', 'Matches Result'
  # No Matches, Matches Result could include tests for 1 character and full name, and show that the match is the first Child of the dropdown parent


  scenario 'Types one character in Search', js: true do
    restaurant = FactoryGirl.create(:restaurant)
    name = restaurant.name
    search_query = name[0]

    given_a_vistor_is_viewing_the_landing_page
    when_they_fill_the_search_bar_with(search_query)
    # pending("they results get shown during the tests")
    they_should_be_shown_the_search_results
    and_the_results_should_include_the(name)
  end

  private
  def given_a_vistor_is_viewing_the_landing_page
    visit '/'
  end

  def when_they_fill_the_search_bar_with(value)
    fill_in('restaurant_name', with: value)
  end

  def they_should_be_shown_the_search_results
    expect(page).to have_css('.typeahead.dropdown-menu')
  end

  def and_the_results_should_include_the(value)
    within('.typeahead.dropdown-menu') do
      expect(page).to have_content(name)
      expect_item_content(restaurant)
    end
  end
end
