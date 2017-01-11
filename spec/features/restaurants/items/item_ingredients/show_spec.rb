require 'rails_helper'

feature 'Show: Ingredients' do
  scenario 'View Ingredients', js: true do
    item = create_restaurant_item_with_ingredients
    restaurant = item.restaurant
    item_ingredients = item.main_item_ingredients

    given_a_vistor_is_viewing_a(:restaurant, restaurant)

    when_they_click_show_ingredients_for_an_item

    they_should_be_shown_the_item_ingredients(item_ingredients)
  end

  def they_should_be_shown_the_item_ingredients(item_ingredients)
    # Sleep for controller to process.  Throws race error without.
    sleep(1)

    item_ingredients.each do |item_ingredient|
      expect(page).to have_content(item_ingredient.name)
    end
  end

  def create_restaurant_item_with_ingredients
    restaurant = FactoryGirl.create(:restaurant)
    item = FactoryGirl.create(:item, restaurant: restaurant)
    FactoryGirl.create(:item_ingredient, item: item)
    item
  end

  def when_they_click_show_ingredients_for_an_item
    click_link('Show Ingredients')
  end
end
