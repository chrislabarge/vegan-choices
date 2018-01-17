require 'rails_helper'

feature 'Content Berries: Item Berries', js: true do
  scenario 'a user gives a berry to another users item' do
    creator = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, user: creator)
    user = FactoryGirl.create(:user)
    count = ContentBerry.all.count
    creators_count = creator.berry_count

    authenticate(user)

    visit restaurant_path(item.restaurant)

    give_berry_to_item_creator

    creator.reload

    expect(page).to have_text('Successfully gave a berry to the user.')
    expect(ContentBerry.all.count).to eq count + 1
    expect(user.items_berried.last).to eq item
    expect(creator.berry_count).to eq creators_count + 1
  end

  scenario 'a user remove a berry from a users item' do
    creator = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item, user: creator)
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:content_berry, item: item, user: user)
    count = ContentBerry.count

    authenticate user

    visit restaurant_path(item.restaurant)

    take_away_berry

    sleep(1)

    actual = ContentBerry.count
    expected = count - 1
    expect(actual).to eq(expected)
    expect(page).to have_text('Took the berry away from the user.')
  end

  scenario 'a visitor cannot give a berry to a users item' do
    # TODO: looks like this is having issues just like the favorite specs

    # restaurant_comment = FactoryGirl.create(:restaurant_comment)
    # comment = restaurant_comment.comment
    # author = restaurant_comment.user
    # restaurant = restaurant_comment.restaurant

    # visit comments_restaurant_path(restaurant)

    # give_berry_to_comment_author

    # expect(page).to have_text("Please Sign In")
    # expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def give_berry_to_item_creator
  drop_accordian
  sleep(1)
  all('.berry .submit').last.trigger('click')
  sleep(1)
end

def drop_accordian
  all('.content.ui.accordion').first.click
end

def take_away_berry
  give_berry_to_item_creator
end

