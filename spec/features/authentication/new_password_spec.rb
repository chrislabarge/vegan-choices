require 'rails_helper'

feature 'Authentication:New Password', js: true do
  scenario 'user forgets password and requests a reset' do
    user = FactoryGirl.create(:user)

    visit new_user_password_path

    reset_password user

    expect(page).to have_text('You will receive an email with instructions on how to reset your password in a few minutes.')
  end

  scenario 'a visitor resets password without an email' do
    visit new_user_password_path

    click_button submit_text

    expect(page).to have_text('Email can\'t be blank')
  end

  scenario 'a visitor resets password with a non record email' do
    user = FactoryGirl.build(:user)

    visit new_user_password_path

    reset_password user

    expect(page).to have_text('Email not found')
  end
end

def submit_text
  'Send me reset password instructions'
end

def reset_password(user)
  fill_in 'Email', with: user.email

  click_button submit_text
end
