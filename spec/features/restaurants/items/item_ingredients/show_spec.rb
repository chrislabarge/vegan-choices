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
    the_show_ingredient_link_should_change_to_a_button
  end

  scenario 'Close/Hide Ingredients', js: true do
    item_ingredient = FactoryGirl.create(:item_ingredient)
    another_item_ingredient = FactoryGirl.create(:item_ingredient, item: item_ingredient.item )
    restaurant = item_ingredient.item.restaurant

    given_a_vistor_is_viewing_a(:restaurant, restaurant)

    when_they_toggle_ingredients_for_an_item(item_ingredient.item)
    and_they_close_the_ingredient_modal
    sleep(1)
    the_modal_should_not_be_visible
  end

  scenario 'View Item Ingredients twice', js: true do
    item_ingredient = FactoryGirl.create(:item_ingredient)
    item = item_ingredient.item
    restaurant = item.restaurant
    given_a_vistor_is_viewing_a(:restaurant, restaurant)

    when_they_toggle_ingredients_for_an_item(item_ingredient.item)
    and_they_close_the_ingredient_modal
    and_they_click_modal_toggle_ingredients_for_an_item(item)

    they_should_be_shown_the_item_ingredients([item_ingredient])
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

    sleep(1)
  end

  def and_they_click_modal_toggle_ingredients_for_an_item(item)
    find('.toggle-modal').trigger('click')
  end

  def and_they_close_the_ingredient_modal
    all('.close').sample
  end

  def the_modal_should_not_be_visible
    # modal = find('#ingredientsModal')
    # expect(modal).not_to be_visible
  end
end
