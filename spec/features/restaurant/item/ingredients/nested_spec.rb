require 'rails_helper'

feature 'Nested: Ingredients' do
  scenario 'Show Nested Ingredients', js: true, j1s_errors: false do
    item = create_restaurant_item_with_nested_ingredients
    restaurant = item.restaurant
    ingredients = item.ingredient_list
    nested_ingredients = ingredients[0].nested

    given_a_vistor_is_viewing_a(:restaurant, restaurant)
    when_they_click_show_contents_for_an_item_ingredient
    they_should_be_shown_the_nested_ingredients(nested_ingredients)
  end

  private

  def create_restaurant_item_with_nested_ingredients
    nested_ingredients = 'Some Ingredient (Nested Ingredient, Another Nested Ingredient)'
    restaurant = FactoryGirl.create(:restaurant)
    FactoryGirl.create(:item, restaurant: restaurant,
                              ingredients: nested_ingredients)
  end

  def when_they_click_show_contents_for_an_item_ingredient
    click_link('Show Ingredients')
    click_button('Show Contents')
  end

  def they_should_be_shown_the_nested_ingredients(nested_ingredients)
    nested_ingredients.each do |ingredient|
      expect(page).to have_content(ingredient.name)
    end
  end
end
