require 'rails_helper'

feature 'User: Destroys Account', js: true do
  let(:diet) { FactoryBot.create(:diet, name: ENV['DIET'])  }

  scenario 'a user deletes their account' do
    user = FactoryBot.create(:user)

    authenticate(user)

    visit edit_user_registration_path

    click_button 'Delete account'

    accept_alert

    sleep(1)

    expect(page).to have_text(' Bye! Your account has been successfully cancelled')
  end

  scenario 'a user that contributed content deletes their account, ophaned content persists' do
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: user)
    item = FactoryBot.create(:item, user: user)

    authenticate(user)

    visit edit_user_registration_path

    click_button 'Delete account'

    accept_alert

    sleep(1)

    expect(page).to have_text(' Bye! Your account has been successfully cancelled')
    expect(restaurant.reload.persisted?).to eq true
    expect(item.reload.persisted?).to eq true
  end
end
