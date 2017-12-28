require 'rails_helper'

feature 'Users: Index', js: true do
  scenario 'View Page' do
    user = FactoryGirl.create(:user)

    visit users_path

    expect(page).to have_content(user.name)
    expect(page).to have_link(user_path user)
  end

  # scenario 'Use Pagination' do
  #   restaurants = create_restaurants(11)

  #   given_a_vistor_is_viewing_a(:restaurant, :index)
  #   when_they_click_next_pagination
  #   they_should_be_shown_the_paginated(restaurants)
  # end

  private

  # def create_restaurants(multiple = nil)
  #   multiple ||= 2

  #   multiple.times { FactoryGirl.create(:restaurant) }
  #   Restaurant.all
  # end

  # def when_they_click_show_ingredients_for_an_item
  #   click_link('Show Ingredients')
  # end

  # def they_should_be_shown_the_restaurants(restaurants)
  #   restaurants.each do |restaurant|
  #     expect_restaurant_index_content(restaurant)
  #   end
  # end

  # def expect_restaurant_index_content(restaurant)
  #   name = case_insensitive_regex(restaurant.name)

  #   within("a[href='/restaurants/#{restaurant.id}']") do
  #     expect(page).to have_content(name)
  #     expect_item_content(restaurant)
  #   end
  # end

  # def expect_item_content(restaurant)
  #   within('.item-count') do
  #     expect(page).to have_content(restaurant.items.count)
  #   end
  # end

  # def when_they_click_next_pagination
  #   all(:css, 'a[rel="next"]').last.click
  # end

  # def they_should_be_shown_the_paginated(restaurants)
  #   expect(page).not_to have_content(restaurants.first.name)
  #   they_should_be_shown_the_restaurants([restaurants.last])
  # end

  # def case_insensitive_regex(string)
  #   /#{string}/i
  # end
end
