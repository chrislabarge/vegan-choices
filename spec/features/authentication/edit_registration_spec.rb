require 'rails_helper'

feature 'Authentication:Registration', js: true do
  scenario 'a user enters an invalid email' do
    user = FactoryGirl.create(:user)
    invalid_email = 'invalid@email'

    authenticate(user)

    visit edit_user_registration_path

    fill_registration_form(user)
    fill_in 'Email', with: invalid_email

    submit_form

    expect(page).to have_text('Email is invalid')
  end

  scenario 'a user does not enter the current password' do
    user = FactoryGirl.create(:user)

    authenticate(user)

    visit edit_user_registration_path

    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    submit_form

    expect(page).to have_text('Current Password can\'t be blank')
  end

  scenario 'a user does not enter the password confirmation' do
    user = FactoryGirl.create(:user)

    authenticate(user)

    visit edit_user_registration_path

    fill_registration_form(user)
    fill_in 'Password', with: 'password'

    submit_form

    expect(page).to have_text('Password Confirmation doesn\'t match Password')
  end

  scenario 'a user does not enter the password' do
    user = FactoryGirl.create(:user)

    authenticate(user)

    visit edit_user_registration_path

    fill_registration_form(user)
    fill_in 'Password confirmation', with: 'password'

    submit_form

    expect(page).to have_text('Password Confirmation doesn\'t match Password')
  end

  scenario 'a user edits their email' do
    user = FactoryGirl.create(:user)
    old_email = user.email
    new_email = 'new@email.com'

    authenticate(user)

    visit edit_user_registration_path

    fill_registration_form(user)
    fill_in 'Email', with: new_email

    submit_form

    user.reload

    expect(page).to have_text('Your account has been updated successfully.')
    expect(user.email).not_to eq(old_email)
    expect(user.email).to eq(new_email)
  end

  scenario 'user edits their password' do
    user = FactoryGirl.create(:user)
    new_password = 'new_password'

    edit_password(user, new_password)

    expect(page).to have_text('Your account has been updated successfully.')
  end

  scenario 'user signs in with newly edited password' do
    user = FactoryGirl.create(:user)
    new_password = 'new_password'

    edit_password(user, new_password)

    click_link('Sign Out')
    click_link('Log In')

    fill_in 'Email', with: user.email
    fill_in 'Password', with: new_password

    click_button 'Log in'

    expect(page).to have_text('Signed in successfully.')
  end
end

def edit_password(user, password)
  authenticate(user)

  visit edit_user_registration_path

  fill_registration_form(user)
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password

  submit_form
end

def fill_registration_form(user)
  fill_in 'Current password', with: user.password
end

def submit_form
  click_button 'Update'
end
