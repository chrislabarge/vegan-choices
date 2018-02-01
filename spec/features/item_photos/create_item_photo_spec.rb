require 'rails_helper'

feature 'User:CreatesItemPhoto', js: true do
  scenario 'a user creates a food item and uploads several photos' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:item_type, name: 'beverage')
    item = FactoryBot.build(:item)
    restaurant = item.restaurant
    item_photo = build(:item_photo, item: item)

    authenticate(user)

    add_new_item_with_multiple_photos(restaurant, item, item_photo)

    expect_successful_creation user

    expect_photos_have_uploaded item_photo
  end

  scenario 'a user creates a uploads a photo for an existing item' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:item_type, name: 'beverage')
    item = FactoryBot.create(:item)
    restaurant = item.restaurant
    item_photo = build(:item_photo, item: item)

    authenticate(user)

    visit item_path item

    click_link 'Add Photo'

    sleep(1)

    attach_file 'New Photo', item_photo.photo

    within('#new_item_photo') do
      find('.ui.circular.button.blue').trigger('click')
    end
    sleep(1)

    expect_photos_have_uploaded item_photo
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
