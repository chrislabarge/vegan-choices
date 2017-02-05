require 'rails_helper'

feature 'Restaurants' do
  scenario 'View Restaurant Index' do
    restaurants = create_restaurants

    given_a_vistor_is_viewing_a(:restaurant, :index)
    they_should_be_shown_the_restaurants(restaurants)
  end

  private

  def create_restaurants
    2.times { FactoryGirl.create(:restaurant) }
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

    within("a[href='/restaurants/#{restaurant.id}']") do
      expect(page).to have_content(name)
      expect_item_content(restaurant)
    end
  end

  def expect_item_content(restaurant)
    expect_menu_item_content(restaurant)
    expect_non_menu_item_content(restaurant)
  end

  def expect_menu_item_content(restaurant)
    within('.menu-items.count') do
      expect(page).to have_content(restaurant.menu_items.count)
    end
  end

  def expect_non_menu_item_content(restaurant)
    within('.non-menu-items.count') do
      expect(page).to have_content(restaurant.non_menu_items.count)
    end
  end

  def case_insensitive_regex(string)
    /#{string}/i
  end
end
