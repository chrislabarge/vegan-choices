require 'rails_helper'

feature 'User:DeletesItemPhoto', js: true do
  scenario 'a user deletes their item photo' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:item_type, name: 'beverage')
    item = FactoryBot.create(:item)
    restaurant = item.restaurant
    item_photo = create(:item_photo, item: item, user: user)
    item_photo_count = ItemPhoto.count

    authenticate(user)

    visit item_path item

    find('.gallery.title').trigger('click')
    sleep(1)
    find('.delete-photo a').trigger('click')
    sleep(1)

    accept_alert

    sleep(1)

    expect(page).to have_content('Successfully removed the photo')
    expect(ItemPhoto.count).to eq(item_photo_count - 1)
  end
end
