require 'rails_helper'

feature 'Top Users:Berries', js: true do
  scenario 'visting top users by berries will display top users' do
    restaurant_comment = FactoryGirl.create(:restaurant_comment)
    comment = restaurant_comment.comment
    author = comment.user
    FactoryGirl.create(:content_berry, comment: comment)

    visit top_users_berries_path

    top_user = all('h3.ui.header').first

    expect(page).to have_text('Top Users')
    expect(page).to have_text(author.name)
    expect(top_user).to have_text(author.name)
  end
end

