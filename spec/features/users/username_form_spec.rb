require 'rails_helper'

feature 'User:Name Form ', js: true do
  scenario 'a user creates a username' do
    user = FactoryGirl.create(:user, name: nil)
    username = "Foo"

    authenticate(user)

    visit user_path(user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Successfully created a username')
  end

  scenario 'a user tries to create a duplicate username' do
    og_user = FactoryGirl.create(:user)
    new_user = FactoryGirl.create(:user, name: nil)

    username = og_user.name

    authenticate(new_user)

    visit user_path(new_user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Name has already been taken')
  end
end
