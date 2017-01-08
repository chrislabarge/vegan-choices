require 'rails_helper'

feature 'Restaurants' do
  scenario 'View Restaurant Items' do
    item = create_restaurant_item
    restaurant = item.restaurant

    given_a_vistor_is_viewing_a(:restaurant, restaurant)
    they_should_be_shown_the_restaurants_items(restaurant.items)
  end

  private

  def create_restaurants
    2.times { FactoryGirl.create(:restaurant) }
    Restaurant.all
  end

  def when_they_click_show_ingredients_for_an_item
    click_link('Show Ingredients')
  end

  def they_should_be_shown_the_restaurants_items(items)
    items.each do |item|
      expect_item_show_content(item)
    end
  end

  def expect_item_show_content(item)
    name = item.name

    expect(page).to have_content(name)
  end

  def create_restaurant_item
    restaurant = FactoryGirl.create(:restaurant)
    FactoryGirl.create(:item, restaurant: restaurant)
  end
end
