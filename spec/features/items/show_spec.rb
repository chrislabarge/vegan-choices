require 'rails_helper'

feature 'Show: Items', js: true do
  scenario 'a signed in item creator/user can edit the item' do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item, user: user)

    authenticate(user)

    visit item_path(item)

    edit_icon.trigger('click')

    expect(page).to have_content('Update the Vegan Option')
  end

  scenario 'a signed in item creator/user cannot report the item' do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item, user: user)

    authenticate(user)

    visit item_path(item)

    expect(page.has_css?('.report-item')).to eq false
  end

  scenario 'a non item creator can report the item' do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item, user: user)
    another_user = FactoryBot.create(:user)

    authenticate(another_user)

    visit item_path(item)

    find('.report-item a').trigger('click')

    expect(page).to have_content 'Reason for Report'
  end

  scenario 'a non item creator cannot edit the item' do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item, user: user)
    another_user = FactoryBot.create(:user)

    authenticate(another_user)

    visit item_path(item)

    expect(page.has_css?('.edit-item')).to eq false
  end
end

def edit_icon
  find('.page-header .edit-item .icon')
end
