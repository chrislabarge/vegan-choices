require 'rails_helper'

feature 'User:ViewsItemPhoto', js: true do
  scenario 'a user views the different item photos' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:item_type, name: 'beverage')
    item = FactoryBot.create(:item)
    restaurant = item.restaurant
    3.times { create(:item_photo, item: item, user: user) }

    authenticate(user)

    visit item_path item

    sleep(1)

    expect(all('.header-img.active').count).to eq(1)
    expect(all('.header-img.hidden', visible: false).count).to eq(2)

    photos_cycle_through_carousel(:right)
    photos_cycle_through_carousel(:left)

    # click_photo
  end
end

def photos_cycle_through_carousel(direction)
  header_images = all('.header-img', visible: false)
  active = find('.header-img.active')

  previous_active_index = header_images.index(active)

  find("a i.angle.#{direction}.icon").trigger('click')

  sleep(1)

  header_images = all('.header-img', visible: false)
  active = find('.header-img.active')

  operator = (direction == :left ? :- : :+)
  current_index = header_images.index(active)

  expect(current_index).to eq previous_active_index.send(operator, 1)
end

def click_photo
  ItemPhoto.all.each do |item_photo|
    allow(item_photo.photo).to receive(:url) { '/images/no-img.jpeg' }
  end

  active = find('.header-img.active')
  active.trigger('click')

  sleep(1)

  expect(find('.full-photo img').present?).to eq true

  find('.purple.big.close').trigger('click')
end
