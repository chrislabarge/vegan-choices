require 'rails_helper'

feature 'User:CreatesItem ', js: true do
  scenario 'a user creates a restaurant food item' do
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:item_type, name: 'beverage')
    item = FactoryGirl.build(:item)
    restaurant = item.restaurant

    authenticate(user)

    visit restaurant_path(restaurant)

    click_link 'Add Vegan Option'

    fill_form_with(item)

    click_button 'Create Vegan Option'

    expect(page).to have_text('Successfully created an item.')
    expect(page).to have_text('Thank you for contributing!')
    expect(Item.last.user).to eq user

    drop_accordian

    expect(find('.content.active')).to have_content(item.name.upcase) || have_content(item.name)
  end

  scenario 'a user tries to create a duplicate item name' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant)
    type = FactoryGirl.create(:item_type)
    existing_item = FactoryGirl.create(:item, item_type: type, restaurant: restaurant)
    new_item = FactoryGirl.build(:item, name: existing_item.name, item_type: type)

    authenticate(user)

    visit restaurant_path(restaurant)

    click_link 'Add Vegan Option'

    fill_form_with(new_item)

    click_button 'Create Vegan Option'

    expect(page).to have_text('Unable to create a new item')
    expect(page).to have_text('Name has already been taken')
  end

  scenario 'a visitor tries to add an item' do
    restaurant = FactoryGirl.create(:restaurant)


    visit restaurant_path(restaurant)

    click_link 'Add Vegan Option'

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def fill_form_with(item)
  fill_in 'Name', with: item.name
  select_type
  fill_in 'Description', with: item.description
  fill_in 'Instructions', with: item.instructions

  # TODO: Eventually allow users to add their own ingredients for the item, if they somehow have them
  #  I should give them like 2 berries for every ingredient or something, I dunno though, people might just take advantage and not give accurate information
  # fill_in 'Ingredients', with: 'An ingredient'
end

def select_type
  find('.ui.dropdown').click
  find('.menu.visible .item').click
end

def drop_accordian
  all('.content.ui.accordion').first.click
end
