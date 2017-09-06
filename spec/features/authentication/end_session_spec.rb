require 'rails_helper'

feature 'Authentication:End The User Session', js: true do
  scenario 'user ends the current session' do
    user = FactoryGirl.create(:user)
    authenticate(user)

    visit user_path(user)

    end_session

    expect(page).to have_text('Signed out successfully.')
  end

  scenario 'a visitor tries to sign a user out' do
    user = FactoryGirl.create(:user)

    visit destroy_user_session_path(user)

    expect(page).to have_text('You need to sign in or sign up before continuing.')
  end
end


def fill_registration_form
  password = 'thisIsaPassword72'

  fill_in 'Email', with: Faker::Internet.email
  fill_in 'Password', with: password
  fill_in 'Confirm Password', with: password
end

def end_session
  within('.footer') { click_link 'Sign Out' }
end
