require 'rails_helper'

feature 'Authentication:Registration', js: true do
  scenario 'a user enters an invalid email' do
    user = FactoryBot.create(:user)
    invalid_email = 'invalid@email'

    authenticate(user)

    visit edit_user_registration_path

    edit_registration_form(user)
    fill_in 'Email', with: invalid_email

    update_registration

    expect(page).to have_text('Email is invalid')
  end

  scenario 'a user does not enter the current password' do
    user = FactoryBot.create(:user)

    authenticate(user)

    visit edit_user_registration_path

    click_button('Yes')
    fill_in 'New Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    update_registration

    expect(page).to have_text('Current Password can\'t be blank')
  end

  scenario 'a user does not enter the password confirmation' do
    user = FactoryBot.create(:user)

    authenticate(user)

    visit edit_user_registration_path

    edit_registration_form(user)
    click_button('Yes')
    fill_in 'New Password', with: 'password'

    update_registration

    expect(page).to have_text('Password Confirmation doesn\'t match Password')
  end

  scenario 'a user does not enter the password' do
    user = FactoryBot.create(:user)

    authenticate(user)

    visit edit_user_registration_path

    edit_registration_form(user)
    click_button('Yes')
    fill_in 'Password confirmation', with: 'password'

    update_registration

    expect(page).to have_text('Password Confirmation doesn\'t match Password')
  end

  scenario 'a user edits their email' do
    user = FactoryBot.create(:user)
    old_email = user.email
    new_email = 'new@email.com'

    authenticate(user)

    visit edit_user_registration_path

    edit_registration_form(user)
    fill_in 'Email', with: new_email

    update_registration

    user.reload

    expect(page).to have_text('Your account has been updated successfully.')
    expect(user.email).not_to eq(old_email)
    expect(user.email).to eq(new_email)
    expect_redirect_to_user_page(user)
  end

  scenario 'user edits their password' do
    user = FactoryBot.create(:user)
    new_password = 'new_password'

    edit_password(user, new_password)

    expect(page).to have_text('Your account has been updated successfully.')
  end

  scenario 'user signs in with newly edited password' do
    user = FactoryBot.create(:user)
    new_password = 'new_password'

    edit_password(user, new_password)

    sign_out

    sleep(1)

    visit new_user_session_path()

    fill_in 'Email', with: user.email
    fill_in 'Password', with: new_password

    click_button 'Sign in'

    expect(page).to have_text('Signed in successfully.')
  end
end

def edit_password(user, password)
  authenticate(user)

  visit edit_user_registration_path

  edit_registration_form(user)

  click_button('Yes')

  fill_in 'New Password', with: password
  fill_in 'Password confirmation', with: password

  update_registration

  expect_redirect_to_user_page(user)
end

def edit_registration_form(user)
  fill_in 'Current Password', with: user.password
end

def update_registration
  click_button 'Update'
end
