require 'rails_helper'

feature 'User:Edit Account', js: true do
  scenario 'a user edits their username' do
    user = FactoryGirl.create(:user)
    new_name = "Tom_Jones"

    authenticate(user)

    visit edit_user_path(user)

    fill_in 'Username', with: new_name

    click_button 'Submit'

    expect(page).to have_text('Successfully updated your profile.')
    expect(user.reload.name).to eq new_name
  end

  scenario 'a user tries to create a duplicate username' do
    og_user = FactoryGirl.create(:user)
    new_user = FactoryGirl.create(:user)
    user_name = og_user.name

    authenticate(new_user)

    visit edit_user_path(new_user)

    fill_in 'Username', with: user_name

    click_button 'Submit'

    expect(page).to have_text('Name has already been taken')
  end
end


