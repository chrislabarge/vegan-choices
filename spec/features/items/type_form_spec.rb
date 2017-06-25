require 'rails_helper'

feature 'Item Type Form', js: true do
  scenario 'can sort the items by restaurant' do
    item = FactoryGirl.create(:item)
    another_item = FactoryGirl.create(:item)

    restaurant = another_item.restaurant

    visit select_item_type_path

    select_restaurant(restaurant)

    expect(page).to have_content(another_item.name)
    expect(page).not_to have_content(item.name)
  end

  scenario 'can select the item to edit' do
    item = FactoryGirl.create(:item)
    another_item = FactoryGirl.create(:item, restaurant: item.restaurant)

    visit select_item_type_path

    find('.ui.dropdown.item').trigger('click')

    sleep(1)

    click_link another_item.name

    expect(page).to have_content(another_item.name)
    expect(page).not_to have_content(item.name)
  end

  scenario 'selecting the item_type successfully updates the item' do
    item = FactoryGirl.create(:item)
    type = FactoryGirl.create(:item_type, name: ItemType.names.first)

    visit select_item_type_path

    within("#edit_item_#{item.id}") do
      find('.ui.dropdown.selection').trigger('click')
      sleep(1)
      find('.item', text: type.name).trigger('click')
    end

    expect(page).to have_content('Updated the item category.')
    expect(page).not_to have_content(item.name)
  end


  def select_restaurant(restaurant)
    within '.restaurant-select' do
      find('.ui.dropdown.selection').trigger('click')
      find('.item', text: restaurant.name).trigger('click')
    end
  end
end

