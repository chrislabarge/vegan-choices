require 'rails_helper'

feature 'Restaurants' do
  scenario 'View Restaurant Items' do
    items = create_restaurant_items
    restaurant = Restaurant.first

    given_a_vistor_is_viewing_a(:restaurant, restaurant)
    they_should_be_shown_the_restaurants_items(items)
    the_items_should_be_in_alphabetical_order(items)
  end

  private

  def create_restaurants
    2.times { FactoryGirl.create(:restaurant) }
    Restaurant.all
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

  def create_restaurant_item()
    restaurant = FactoryGirl.create(:restaurant)
    FactoryGirl.create(:item_diet, item: FactoryGirl.create(:item, restaurant: restaurant)).item
  end

  def create_restaurant_items()
    item_diet = FactoryGirl.create(:item_diet)
    diet = item_diet.diet
    item = item_diet.item
    restaurant = item.restaurant
    another_item = FactoryGirl.create(:item, restaurant: restaurant)
    FactoryGirl.create(:item_diet, diet: diet, item: another_item)

    item.update(name: 'z')
    another_item.update(name: 'a')

    [item, another_item]
  end

  def the_items_should_be_in_alphabetical_order(items)
    sorted_items = items.sort_by{ |i| i.name }
    visable_page_items = all('.restaurant-item')

    expect(visable_page_items.first.text).to eq sorted_items.first.name
    expect(visable_page_items.last.text).to eq sorted_items.last.name
  end
end
