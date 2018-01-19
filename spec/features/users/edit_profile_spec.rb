require 'rails_helper'

feature 'User:Edit Account', js: true do
  scenario 'a user edits their username' do
    user = FactoryBot.create(:user)
    new_name = "Tom_Jones"

    authenticate(user)

    visit edit_user_path(user)

    fill_in 'Username', with: new_name

    click_button 'Submit'

    expect(page).to have_text('Successfully updated your profile.')
    expect(user.reload.name).to eq new_name
  end

  scenario 'a user edits their location' do
    user = FactoryBot.create(:user)
    location = create(:location, user: user)
    new_location = build(:location)

    authenticate(user)

    visit edit_user_path(user)

    fill_in 'Country', with: new_location.country
    fill_in 'State', with: new_location.state
    fill_in 'City', with: new_location.city

    click_button 'Submit'

    location.reload

    expect(page).to have_text('Successfully updated your profile.')
    expect(location.country).to eq new_location.country
    expect(location.state).to eq new_location.state
    expect(location.city).to eq new_location.city
  end

  scenario 'a user tries to create a duplicate username' do
    og_user = FactoryBot.create(:user)
    new_user = FactoryBot.create(:user)
    user_name = og_user.name

    authenticate(new_user)

    visit edit_user_path(new_user)

    fill_in 'Username', with: user_name

    click_button 'Submit'

    expect(page).to have_text('Name has already been taken')
  end
end


