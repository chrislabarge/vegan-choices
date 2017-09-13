require 'rails_helper'

feature 'Authentication:Registration', js: true do
  scenario 'registree provides an invalid email' do
    invalid_email = 'not-a-valid-email.com'

    visit new_user_registration_path
    fill_registration_form
    fill_in 'Email', with: invalid_email

    submit_form

    expect(page).to have_text('Email is invalid')
  end

  scenario 'registree provides a non matching password' do
    non_matching_password = 'foo'

    visit new_user_registration_path
    fill_registration_form
    fill_in 'Password', with: non_matching_password

    submit_form

    expect(page).to have_text("Password Confirmation doesn't match Password")
  end

  scenario 'registree successfully fills out the form' do
    visit new_user_registration_path
    fill_registration_form

    submit_form

    expect(page).to have_text("Welcome! You have signed up successfully")
  end
end

def fill_registration_form
  password = 'thisIsaPassword72'

  fill_in 'Email', with: Faker::Internet.email
  fill_in 'Password', with: password
  fill_in 'Confirm Password', with: password
end

def submit_form
  click_button 'Sign up'
end
