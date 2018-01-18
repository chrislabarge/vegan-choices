require 'rails_helper'

feature 'Content Berries: Comment Berries', js: true do
  scenario 'a user gives a berry to another users comment' do
    restaurant_comment = FactoryBot.create(:restaurant_comment)
    comment = restaurant_comment.comment
    author = restaurant_comment.user
    restaurant = restaurant_comment.restaurant
    user = FactoryBot.create(:user)
    count = ContentBerry.all.count
    authors_berry_count = author.berry_count

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    give_berry_to_comment_author
    author.reload

    expect(page).to have_text('Successfully gave a berry to the user.')
    expect(ContentBerry.all.count).to eq count + 1
    expect(user.comments_berried.last).to eq comment
    expect(author.berry_count).to eq authors_berry_count += 1
  end

  scenario 'a user remove a berry from a comment' do
    restaurant_comment = FactoryBot.create(:restaurant_comment)
    comment = restaurant_comment.comment
    author = restaurant_comment.user
    restaurant = restaurant_comment.restaurant
    user = FactoryBot.create(:user)
    content_berry = FactoryBot.create(:content_berry, comment: comment, user: user)
    count = ContentBerry.count

    authenticate user

    visit comments_restaurant_path(restaurant)

    take_away_berry

    actual = ContentBerry.count
    expected = count - 1
    expect(actual).to eq(expected)
    expect(page).to have_text('Took the berry away from the user.')
  end

  scenario 'a visitor cannot add a user to favorites' do
    # TODO: looks like this is having issues just like the favorite specs

    # restaurant_comment = FactoryBot.create(:restaurant_comment)
    # comment = restaurant_comment.comment
    # author = restaurant_comment.user
    # restaurant = restaurant_comment.restaurant

    # visit comments_restaurant_path(restaurant)

    # give_berry_to_comment_author

    # expect(page).to have_text("Please Sign In")
    # expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def give_berry_to_comment_author
  find('.submit').click
  sleep(1)
end

def take_away_berry
  give_berry_to_comment_author
end

def remove_from_favorites
  add_to_favorites
end
