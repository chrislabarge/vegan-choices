require 'rails_helper'

feature 'Authentication:Edit Password', js: true do
  scenario 'edit password' do
    user = FactoryGirl.create(:user)
    new_password = 'sazDasd'

    edit_password(user, new_password)

    expect(page).to have_text 'Your account has been updated successfully'
  end

  scenario 'sign in with new password' do
    user = FactoryGirl.create(:user)
    new_password = 'sazDasd'

    sign_in_with_edited_password(user, new_password)

    expect(page).to have_text 'Signed in successfully.'
  end
end

def submit_text
  'Reset password'
end

def reset_password(user)
  fill_in 'Email', with: user.email

  click_button submit_text
end

def edit_password(user, password)
  visit new_user_password_path

  fill_in 'Email', with: user.email

  click_button submit_text

  expect(unread_emails_for(user.email)).to be_present

  open_email(user.email, with_subject: 'Reset password instructions')

  click_first_link_in_email

  fill_in 'New password', with: password
  fill_in 'Confirm new password', with: password
  click_button 'Change password'
end

def sign_in_with_edited_password(user, new_password)
  edit_password(user, new_password)

  within('.footer'){ click_link 'Sign Out' }
  within('.footer'){ click_link 'Log In' }


  fill_in 'Email', with: user.email
  fill_in 'Password', with: new_password

  click_button 'Log in'
end
