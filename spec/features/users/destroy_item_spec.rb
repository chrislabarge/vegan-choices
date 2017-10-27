require 'rails_helper'

feature 'User: Destroys Item ', js: true do
  let(:diet) { FactoryGirl.create(:diet, name: ENV['DIET'])  }

  scenario 'a user deletes a restaurants food item' do
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, item_type: FactoryGirl.create(:item_type, name: 'beverage'), user: user)
    FactoryGirl.create(:item_diet, item: item, diet: diet)
    restaurant = item.restaurant

    authenticate(user)

    visit restaurant_path(restaurant)

    drop_accordian

    click_link 'Delete'

    accept_alert

    sleep(1)

    drop_accordian

    expect(page).not_to have_text(item.name.upcase)
    expect(page).to have_text('Successfully deleted the item.')
  end

  scenario 'a visitor cannot delete an item' do
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, item_type: FactoryGirl.create(:item_type, name: 'beverage'), user: user)
    FactoryGirl.create(:item_diet, item: item, diet: diet)
    restaurant = item.restaurant

    visit restaurant_path(restaurant)

    drop_accordian

    expect(page).not_to have_link("Delete")
  end
end

def drop_accordian
  all('.content.ui.accordion').first.click
end
