require 'rails_helper'

feature 'User:Name Form ', js: true do
  scenario 'a user creates a username upon signing in for the first time' do
    user = FactoryGirl.create(:user, name: nil)
    username = "Foo"

    authenticate(user)

    expect(page).to have_text('Please create a username')

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Successfully created a username')
    expect(user.reload.name).to eq(username)

    within('.footer') do
      click_link 'Sign Out'
    end

    authenticate(user)

    expect(page).not_to have_text('Please create a username')
  end

  scenario 'a user tries to create a duplicate username' do
    og_user = FactoryGirl.create(:user)
    new_user = FactoryGirl.create(:user, name: nil)
    username = og_user.name

    authenticate(new_user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Name has already been taken')

    click_button 'Submit'

    expect(page).to have_text('Name has already been taken')
  end

  scenario 'a user tries to create an invalid username' do
    user = FactoryGirl.create(:user, name: nil)
    username = 'invalid user name'

    authenticate(user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Name is invalid')

    click_button 'Submit'

    expect(page).to have_text('Name is invalid')
  end
end
