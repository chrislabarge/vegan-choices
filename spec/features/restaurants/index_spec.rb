require 'rails_helper'

feature 'Restaurants', js: true do
  scenario 'View Restaurant Index' do
    restaurants = create_restaurants

    given_a_visitor_is_viewing_a(:restaurant, :index)
    they_should_be_shown_the_restaurants(restaurants)
  end

  scenario 'Use Restaurant Pagination' do
    restaurants = create_restaurants(11)

    visit restaurants_path(sort_by: 'name')

    when_they_click_next_pagination
    they_should_be_shown_the_paginated(restaurants)
  end

  scenario 'Sortable Restaurants by Recently Added' do
    restaurants = create_restaurants(11)

    visit restaurants_path(sort_by: 'recent')

    first_page_restaurants = Restaurant.order("created_at DESC")[0...9]

    they_should_be_shown_the_restaurants first_page_restaurants

    when_they_click_next_pagination

    they_should_be_shown_the_paginated(restaurants)
  end

  private

  def create_restaurants(multiple = nil)
    multiple ||= 2

    multiple.times { FactoryBot.create(:restaurant) }
    Restaurant.all
  end

  def when_they_click_show_ingredients_for_an_item
    click_link('Show Ingredients')
  end

  def they_should_be_shown_the_restaurants(restaurants)
    restaurants.each do |restaurant|
      expect_restaurant_index_content(restaurant)
    end
  end

  def expect_restaurant_index_content(restaurant)
    name = case_insensitive_regex(restaurant.name)

    within("a[href$='/restaurants/#{restaurant.slug}']") do
      expect(page).to have_content(name)
      expect_item_content(restaurant)
    end
  end

  def expect_item_content(restaurant)
    within('.item-count') do
      count = restaurant.items.count
      expected = (count > 0 ? count : 'Add')

      expect(page).to have_content(expected)
    end
  end

  def when_they_click_next_pagination
    all(:css, 'a[rel="next"]').last.click
  end

  def they_should_be_shown_the_paginated(restaurants)
    expect(all('.restaurant-list .content.list-row').count).to eq 1
  end

  def case_insensitive_regex(string)
    /#{string}/i
  end
end
