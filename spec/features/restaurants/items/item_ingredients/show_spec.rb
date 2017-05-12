require 'rails_helper'

feature 'Show: Ingredients' do
  before :all do
    create_all_item_types
  end

  after :all do
    destroy_all_item_types
  end

  scenario 'View Ingredients', js: true do
    item_ingredient = FactoryGirl.create(:item_ingredient)
    another_item_ingredient = FactoryGirl.create(:item_ingredient, item: item_ingredient.item )
    restaurant = item_ingredient.item.restaurant

    given_a_vistor_is_viewing_a(:restaurant, restaurant)

    when_they_toggle_ingredients_for_an_item(item_ingredient.item)

    they_should_be_shown_the_item_ingredients([item_ingredient, another_item_ingredient])
  end

  scenario 'View Item Ingredients twice', js: true do
    item_ingredient = FactoryGirl.create(:item_ingredient)
    restaurant = item_ingredient.item.restaurant

    given_a_vistor_is_viewing_a(:restaurant, restaurant)

    when_they_toggle_the_ingredients_the_button_changes([item_ingredient])

    the_show_ingredient_link_should_change_to_a_button
  end

  def when_they_toggle_the_ingredients_the_button_changes(item_ingredients)
    item = item_ingredients.first.item

    when_they_toggle_ingredients_for_an_item(item)

    they_should_be_shown_the_item_ingredients(item_ingredients)

    when_they_close_the_ingredient_modal

    when_they_click_modal_toggle_ingredients_for_an_item(item)
  end

  def the_show_ingredient_link_should_change_to_a_button
    expect(page.find('.toggle-modal').visible?).to eq true
  end

  def they_should_be_shown_the_item_ingredients(item_ingredients)
    sleep(1)

    item_ingredients.each do |item_ingredient|
      expect(page).to have_content(item_ingredient.name)
    end
  end

  def when_they_toggle_ingredients_for_an_item(item)
    all('.title').first.trigger('click')

    click_link(item.name)
  end

  def when_they_click_modal_toggle_ingredients_for_an_item(item)
    find('.toggle-modal').trigger('click')
  end

  def when_they_close_the_ingredient_modal
    all('.close').last.click
  end
end
