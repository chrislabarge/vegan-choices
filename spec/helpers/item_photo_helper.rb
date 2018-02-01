module ItemPhotoHelper
  def expect_photos_have_uploaded(item_photo)
    visit item_path Item.last

    gallery_images = all('.header-img.active')
    hidden = all('.header-img.hidden', visible: false)

    expect(gallery_images.count).to eq 1
    expect(hidden.count).to eq Item.last.photos.count - 1

    expected_url = item_photo.photo.thumb.url

    [gallery_images, hidden].each { |collection| expect_correct_urls(collection, expected_url)  }
  end

  def expect_successful_creation(user)
    expect(page).to have_text('Successfully created an item.')
    expect(page).to have_text('Thank you for contributing!')
    expect(Item.last.user).to eq user
  end

  def add_new_item_with_multiple_photos(restaurant, item, item_photo)
    visit restaurant_path(restaurant)

    click_link 'Add Vegan Option'

    fill_form_with(item)

    2.times { add_photo item_photo }

    click_button 'Create Vegan Option'

    drop_accordian

    expect(all('.restaurant-items').first).to have_content(item.name.upcase) || have_content(item.name)
  end

  def add_photo(item_photo)
    click_link ('Add Photo')

    fill_in_item_photo_form(item_photo)
  end

  def expect_correct_urls(nodes, expected_url)
    img_sources = nodes.map { |img| img[:src] }

    img_sources.each do |source|
      expect(source).to include(expected_url)
    end
  end

  def fill_in_item_photo_form(model)
    within(all('#item_photos .field').last) do
      attach_file 'New Photo', model.photo
    end
  end
end
