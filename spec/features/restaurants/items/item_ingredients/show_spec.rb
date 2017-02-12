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

  scenario 'View Item Ingredients twice', js: true do
    item = create_restaurant_item_with_ingredients
    restaurant = item.restaurant
    item_ingredients = item.main_item_ingredients

    given_a_vistor_is_viewing_a(:restaurant, restaurant)

    when_they_toggle_the_ingredients_the_button_changes(item_ingredients)
  end

  def when_they_toggle_the_ingredients_the_button_changes(item_ingredients)
    when_they_click_show_ingredients_for_an_item

    they_should_be_shown_the_item_ingredients(item_ingredients)

    when_they_close_the_ingredient_modal

    when_they_click_modal_toggle_ingredients_for_an_item
  end

  def the_show_ingredient_button_should_change
    expect(page.find_link('Show Ingredients').visible?).not_to eq true
    expect(page.find_button('Show Ingredients').visible?).to eq true
  end

  def they_should_be_shown_the_item_ingredients(item_ingredients)
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

  def when_they_click_modal_toggle_ingredients_for_an_item
    click_button('Show Ingredients')
  end

  def when_they_close_the_ingredient_modal
    find(:css, '.close').click
  end
end
