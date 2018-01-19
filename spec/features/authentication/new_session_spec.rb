require 'rails_helper'

feature 'Authentication:New User Session', js: true do
  scenario 'a user signs in' do
    create_new_user_session

    expect(page).to have_text('Signed in successfully.')
  end

  scenario 'a user signs in with omniauth' do
    mock_geocoding!

    visit new_user_session_path

    find('#twitterLogin').click

    expect(page).to have_text('Successfully authenticated from Twitter account.')
  end

  scenario 'an existing user signs in with omniauth' do
    user = FactoryBot.create(:user)
    user_count = User.count

    OmniAuth.config.add_mock(:twitter, {:info => {email: user.email}})

    visit new_user_session_path

    find('#twitterLogin').click

    expect(page).to have_text('Successfully authenticated from Twitter account.')
    expect(User.count).to eq(user_count)
  end

  scenario 'user signs in with an invalid email' do
    visit new_user_session_path

    fill_in 'Email', with: 'invalid@email'
    fill_in 'Password', with: 'password'

    click_button 'Sign in'

    expect(page).to have_text(unsuccessful_message)
  end

  scenario 'user signs in with wrong email' do
    user = FactoryBot.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: 'wrong@email.com'
    fill_in 'Password', with: user.password

    click_button 'Sign in'

    expect(page).to have_text(unsuccessful_message)
  end

  scenario 'user signs in with wrong password' do
    user = FactoryBot.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'foobar'

    click_button 'Sign in'

    expect(page).to have_text(unsuccessful_message)
  end

  scenario 'user signs in with remember me' do
    user = FactoryBot.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    find(:css, '.toggle').click()

    click_button 'Sign in'

    expect(page.driver.cookies['remember_user_token']).to be_present
  end
end

def create_new_user_session
  user = FactoryBot.create(:user)
  authenticate(user)
end

def unsuccessful_message
  'Invalid Email or password'
end
