require 'rails_helper'


feature 'User:CreatesItem ', js: true do
  scenario 'a user creates a restaurant food item' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:item_type, name: 'beverage')
    item = FactoryBot.build(:item)
    restaurant = item.restaurant
    item_photo = build(:item_photo, item: item)

    authenticate(user)

    add_new_item_with_multiple_photos(restaurant, item, item_photo)

    visit item_path Item.last

    gallery_images = all('.header-img')

    img_sources = gallery_images.map { |img| img[:src] }
    img_sources.each do |source|
      expect(source).to include(item_photo.photo.thumb.url)
    end
  end

  scenario 'a user tries to create a duplicate item name' do
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant)
    type = FactoryBot.create(:item_type)
    existing_item = FactoryBot.create(:item, item_type: type, restaurant: restaurant)
    new_item = FactoryBot.build(:item, name: existing_item.name, item_type: type)

    authenticate(user)

    visit restaurant_path(restaurant)

    click_link 'Add Vegan Option'


    fill_form_with(new_item)

    click_button 'Create Vegan Option'

    expect(page).to have_text('Unable to create a new item')
    expect(page).to have_text('Name has already been taken')
  end

  scenario 'a visitor tries to add an item' do
    restaurant = FactoryBot.create(:restaurant)


    visit restaurant_path(restaurant)

    click_link 'Add Vegan Option'

    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def fill_form_with(item)
  within('.ui.form.large') do
    fill_in 'Name', with: item.name
    select_type
    fill_in 'Description', with: item.description
    fill_in 'Instructions', with: item.instructions
  end
end

def drop_accordian
  all('.food-items .dropdown.icon').first.trigger('click')
  sleep(1)
end
