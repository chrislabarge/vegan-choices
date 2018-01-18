require 'rails_helper'

feature 'User: Destroys Item ', js: true do
  let(:diet) { FactoryBot.create(:diet, name: ENV['DIET'])  }

  scenario 'a user deletes a restaurants food item' do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item, item_type: FactoryBot.create(:item_type, name: 'beverage'), user: user)
    FactoryBot.create(:item_diet, item: item, diet: diet)
    restaurant = item.restaurant

    authenticate(user)

    visit edit_item_path(item)

    click_delete

    accept_alert

    sleep(1)

    drop_accordian

    expect(page).not_to have_text(item.name.upcase)
    expect(page).to have_text('Successfully deleted the item.')
  end

  scenario 'a visitor cannot delete an item' do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item, item_type: FactoryBot.create(:item_type, name: 'beverage'), user: user)
    FactoryBot.create(:item_diet, item: item, diet: diet)
    restaurant = item.restaurant

    visit restaurant_path(restaurant)

    drop_accordian

    expect(page).not_to have_link("Delete")
  end
end

def drop_accordian
  all('.content.ui.accordion').first.trigger('click')
end

def click_delete
  find('.delete-item i').trigger('click')
end
