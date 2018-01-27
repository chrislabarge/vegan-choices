require 'rails_helper'

feature 'User:Name Form ', js: true do
  before(:each) { mock_geocoding! }

  scenario 'a user creates a username upon signing in for the first time' do
    user = FactoryBot.create(:user, name: nil)
    username = "Foo"

    authenticate(user)

    expect(page).to have_text('Please create a profile')

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Successfully created a profile')
    expect(user.reload.name).to eq(username)

    find('.user.circle.icon').trigger('click')
    find('a[href="/users/sign_out"]').trigger('click')

    sleep(1)

    authenticate(user)

    expect(page).not_to have_text('Please create a profile')
  end

  scenario 'a user tries to create a duplicate username' do
    og_user = FactoryBot.create(:user)
    new_user = FactoryBot.create(:user, name: nil)
    username = og_user.name

    authenticate(new_user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Name has already been taken')
  end

  scenario 'a user tries to create an invalid username' do
    user = FactoryBot.create(:user, name: nil)
    username = 'invalid user name'

    authenticate(user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Unable to update your profile')
    expect(page).to have_text('Name can only contain letters, numbers or underscore characters. No Spaces.')
  end

  scenario 'a user tries to create a username that is too short' do
    user = FactoryBot.create(:user, name: nil)
    username = 'so'

    authenticate(user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Unable to update your profile')
    expect(page).to have_text('Name needs to be 3 to 25 characters long')
  end

  scenario 'a user tries to create a username that is too long' do
    user = FactoryBot.create(:user, name: nil)
    username = ''
    26.times { username += 't' }

    authenticate(user)

    fill_in 'Username', with: username

    click_button 'Submit'

    expect(page).to have_text('Unable to update your profile')
    expect(page).to have_text('Name needs to be 3 to 25 characters long')
  end
end
