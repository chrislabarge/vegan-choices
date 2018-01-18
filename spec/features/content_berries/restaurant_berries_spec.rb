require 'rails_helper'

feature 'Content Berries: Restaurant Berries', js: true do
  scenario 'a user gives a berry to another users restaurant' do
    creator = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: creator)
    user = FactoryBot.create(:user)
    count = ContentBerry.all.count
    creators_count = creator.berry_count

    authenticate(user)

    visit restaurant_path(restaurant)

    give_berry_to_restaurant_creator

    creator.reload

    expect(page).to have_text('Successfully gave a berry to the user.')
    expect(ContentBerry.all.count).to eq count + 1
    expect(user.restaurants_berried.last).to eq restaurant
    expect(creator.berry_count).to eq creators_count += 1
  end

  scenario 'a user remove a berry from a users restaurant' do
    creator = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: creator)
    user = FactoryBot.create(:user)
    FactoryBot.create(:content_berry, restaurant: restaurant, user: user)
    count = ContentBerry.count

    authenticate user

    visit restaurant_path(restaurant)

    take_away_berry

    actual = ContentBerry.count
    expected = count - 1
    expect(actual).to eq(expected)
    expect(page).to have_text('Took the berry away from the user.')
  end

  # scenario 'a visitor cannot give a berry to a users restaurant' do
  #   creator = FactoryBot.create(:user)
  #   restaurant = FactoryBot.create(:restaurant, user: creator)

  #   visit restaurant_path(restaurant)

  #   give_berry_to_restaurant_creator

  #   expect(page).to have_text("Please Sign In")
  #   expect(page).to have_text("You need to sign in or sign up before continuing.")
  # end
end

def give_berry_to_restaurant_creator
  find('.berry .submit').click
  sleep(1)
end

def take_away_berry
  give_berry_to_restaurant_creator
end
