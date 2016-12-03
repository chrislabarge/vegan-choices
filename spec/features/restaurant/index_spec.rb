require 'rails_helper'

feature 'Restaurants' do
  scenario 'View Restaurant Index' do
    restaurants = create_restaurants

    given_a_vistor_is_viewing_a(:restaurant, :index)
    they_should_be_shown_the_restaurants(restaurants)
  end

  private

  def create_restaurants #TODO: refactor this into a one liner, mapping
    2.times { FactoryGirl.create(:restaurant) }
    Restaurant.all
  end

  def when_they_click_show_ingredients_for_an_item
    click_link('Show Ingredients')
  end

  def they_should_be_shown_the_restaurants(restaurants)
    restaurants.each do |restaurant|
      name = case_insensitive_regex(restaurant.name)

      expect(page).to have_content(name)
    end
  end

  def case_insensitive_regex(string)
    /#{string}/i
  end
end
