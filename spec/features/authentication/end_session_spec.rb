require 'rails_helper'

feature 'Authentication:End The User Session', js: true do
  scenario 'user ends the current session' do
    user = FactoryGirl.create(:user)
    authenticate(user)

    visit user_path(user)

    sign_out

    expect(page).to have_text('Signed out successfully.')
  end

  scenario 'a visitor tries to sign a user out' do
    user = FactoryGirl.create(:user)

    #TODO: Find a method to make a delete request to the server to remove the model
    # page.driver.delete("/users/sign_out")

    # expect(page).to have_text('You need to sign in or sign up before continuing.')
  end
end
