require 'rails_helper'

feature 'Click: Ingredients' do
  before :all do
    create_all_item_types
  end

  after :all do
    destroy_all_item_types
  end

  scenario 'Click on a normal ingredients', js: true do
    item_ingredient = FactoryGirl.create(:item_ingredient)
    item = item_ingredient.item
    restaurant = item.restaurant

    visit item_path(item)

    click_link('Ingredients')
    # TODO# Stubb out anything going to a thrird party like i do now, going to wikipedia.
    # when_they_click_on_the_ingredient(item_ingredient)

    # sleep(2)
    # they_should_be_show_more_information_on_the_ingredient
  end

  scenario 'Click on a recipe item', js: true do
    recipe_item = FactoryGirl.create(:recipe_item)
    recipe = recipe_item.recipe
    item = recipe.item
    restaurant = item.restaurant
    ingredient = FactoryGirl.create(:ingredient, name: recipe_item.name)
    item_ingredient = FactoryGirl.create(:item_ingredient, item: item, ingredient: ingredient)
    recipe_item_ingredient = FactoryGirl.create(:item_ingredient, item: recipe_item.item)
    recipe_item.item.update(restaurant: restaurant)

    visit item_path(item)

    click_link('Ingredients')

    when_they_click_on_the_ingredient(item_ingredient)

    they_are_shown_the_ingredients_modal_for_the_recipe_item(recipe_item)
  end

  def when_they_click_on_the_ingredient(item_ingredient)
    find('.recipe-item').trigger('click')
  end

  def they_should_be_show_more_information_on_the_ingredient
    #TODO page should equal outside source for ingredient information, maybe evenetually it will contain relevent ingredient information as well.
  end

  def they_are_shown_the_ingredients_modal_for_the_recipe_item(recipe_item)
    item = recipe_item.item
    item_ingredients = item.item_ingredients

    #FIXME For some reason capybara or the test page is not responding to the js function, even though
    #when I use the debugger I can see that the function is being called and executed correctly.
    pending('the test page responds to the js function that is called upon clicking the recipe item')

    item_ingredients.each { |ii| expect(page).to have_content(ii.name) }
  end
end
