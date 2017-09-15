require 'rails_helper'

feature 'Authentication:New User Session', js: true do
  scenario 'a user signs in' do
    create_new_user_session

    expect(page).to have_text('Signed in successfully.')
  end

  scenario 'user signs in with an invalid email' do
    visit new_user_session_path

    fill_in 'Email', with: 'invalid@email'
    fill_in 'Password', with: 'password'

    click_button 'Log in'

    expect(page).to have_text(unsuccessful_message)
  end

  scenario 'user signs in with wrong email' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: 'wrong@email.com'
    fill_in 'Password', with: user.password

    click_button 'Log in'

    expect(page).to have_text(unsuccessful_message)
  end

  scenario 'user signs in with wrong password' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'foobar'

    click_button 'Log in'

    expect(page).to have_text(unsuccessful_message)
  end

  scenario 'user signs in with remember me' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    find(:css, '.toggle').click()

    click_button 'Log in'

    expect(page.driver.cookies['remember_user_token']).to be_present
  end
end

def create_new_user_session
  user = FactoryGirl.create(:user)
  authenticate(user)
end

def unsuccessful_message
  'Invalid Email or password'
end

def end_session
  within('.footer') { click_link 'Sign Out' }
end
