require 'rails_helper'

feature 'User: Updates Item ', js: true do
  scenario 'a user updates a restaurants food item' do
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, item_type: FactoryGirl.create(:item_type, name: 'beverage'), user: user)
    FactoryGirl.create(:item_diet, item: item, diet: Diet.first)
    restaurant = item.restaurant
    new_item_content = FactoryGirl.build(:item)

    authenticate(user)

    visit restaurant_path(restaurant)

    drop_accordian

    click_link 'Edit'

    fill_form_with(new_item_content)

    click_button 'Update Vegan Option'

    item.reload

    expect(page).to have_text('Successfully updated the item.')
    expect(page).to have_text('Thank you for contributing!')
    expect(item.name).to eq new_item_content.name
    expect(item.description).to eq new_item_content.description
    expect(item.instructions).to eq new_item_content.instructions
  end

  scenario 'a user tries to update name to a duplicate item name' do
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, item_type: FactoryGirl.create(:item_type, name: 'beverage'), user: user)
    existing_item = item.dup;
    existing_item.update(name: 'a name')
    FactoryGirl.create(:item_diet, item: item, diet: Diet.first)
    restaurant = item.restaurant
    new_item_content = FactoryGirl.build(:item, name: existing_item.name)

    authenticate(user)

    visit restaurant_path(restaurant)

    drop_accordian

    all('.edit-item').last.click()

    sleep(2)

    fill_form_with(new_item_content)

    click_button 'Update Vegan Option'

    expect(page).to have_text('Unable to update the item')
    expect(page).to have_text('Name has already been taken')
  end

  scenario 'a visitor cannot edit an item' do
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, item_type: FactoryGirl.create(:item_type, name: 'beverage'), user: user)
    FactoryGirl.create(:item_diet, item: item, diet: Diet.first)
    restaurant = item.restaurant

    visit restaurant_path(restaurant)

    drop_accordian

    expect(page).not_to have_link("Edit")

    visit edit_item_path(item)

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end

  scenario 'a user cannot edit another users item' do
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, item_type: FactoryGirl.create(:item_type, name: 'beverage'), user: user)
    FactoryGirl.create(:item_diet, item: item, diet: Diet.first)
    new_user = FactoryGirl.create(:user)

    authenticate(new_user)

    visit edit_item_path(item)

    expect(page).to have_text("You do not have permission to view this page.")
  end
end

def fill_form_with(item)
  fill_in 'Name', with: item.name
  fill_in 'Description', with: item.description
  fill_in 'Instructions', with: item.instructions

  # TODO: Eventually allow users to add their own ingredients for the item, if they somehow have them
  #  I should give them like 2 berries for every ingredient or something, I dunno though, people might just take advantage and not give accurate information
  # fill_in 'Ingredients', with: 'An ingredient'
end

def select_type
  find('.ui.dropdown').click
  sleep(1)
  find('.menu.visible .item').click
end

def drop_accordian
  all('.content.ui.accordion').first.click
end
