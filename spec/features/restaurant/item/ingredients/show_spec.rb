require 'rails_helper'

feature 'Show: Ingredients' do
  scenario 'View Ingredients', js: true, js_errors: false do
    item = create_restaurant_item_with_ingredients
    restaurant = item.restaurant
    ingredients = item.ingredient_list

    given_a_vistor_is_viewing_a(:restaurant, restaurant)
    when_they_click_show_ingredients_for_an_item
    they_should_be_shown_the_ingredients(ingredients)
  end

  private

  def create_restaurant_item_with_ingredients
    ingredients = 'Some Ingredient'
    restaurant = FactoryGirl.create(:restaurant)
    FactoryGirl.create(:item, restaurant: restaurant,
                              ingredients: ingredients)
  end

  def when_they_click_show_ingredients_for_an_item
    click_link('Show Ingredients')
  end

  def they_should_be_shown_the_ingredients(ingredients)
    ingredients.each do |ingredient|
      expect(page).to have_content(ingredient.name)
    end
  end
end
