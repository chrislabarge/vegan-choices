require 'rails_helper'

feature 'Favorites:FavoriteUser', js: true do
  scenario 'a user favorites a another user' do
    user = FactoryGirl.create(:user)
    another_user = FactoryGirl.create(:user)

    authenticate(user)

    visit user_path(another_user)

    add_to_favorites

    expect(page).to have_text('You have added the user to your favorites.')
    expect(user.favorite_users).to include another_user
  end

  scenario 'a user can be unfavorited' do
    user = FactoryGirl.create(:user)
    favorite = FactoryGirl.create(:favorite, profile: user)
    follower = favorite.user
    favorite_count = Favorite.count

    authenticate follower

    visit user_path(user)

    remove_from_favorites

    save_screenshot 'fuoo.png', full: true

    actual = Favorite.count
    expected = favorite_count - 1
    expect(actual).to eq(expected)
  end

  scenario 'a visitor cannot add a user to favorites' do
    # user = FactoryGirl.create(:user)

    # visit user_path(user)

    # add_to_favorites

    # expect(page).to have_text("Please Sign In")
    # expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def add_to_favorites
  find('.submit').click
  sleep(1)
end

def remove_from_favorites
  add_to_favorites
end
