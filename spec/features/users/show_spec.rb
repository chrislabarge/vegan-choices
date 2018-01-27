require 'rails_helper'

feature 'User:Show Page', js: true do
  scenario 'a user\'s favorite restaurants are displayed on their show page' do
    restaurant = FactoryBot.create(:restaurant)
    favorite = FactoryBot.create(:favorite, restaurant: restaurant)

    user = favorite.user

    authenticate(user)

    expect(page).to have_text('Favorite Restaurants')
    expect(page).to have_text(restaurant.name)
  end

  # scenario 'a user\'s berry count is displayed on their homepage ' do
  #   comment = FactoryBot.create(:comment)
  #   user = comment.user
  #   berry = FactoryBot.create(:content_berry, comment: comment)

  #   authenticate(user)

  #   actual = find('.berry .floating.label').text()

  #   expect(actual).to eq('2')
  # end

  # scenario 'a visitor to a user page is show the users comments' do
  #   comment = FactoryBot.create(:comment)

  #   visit user_path comment.user

  #   expect(page).to have_text('Submitted Comments')
  #   expect(page).to have_text(comment.content)
  # end
end

