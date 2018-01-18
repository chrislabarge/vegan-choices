require 'rails_helper'

feature 'Top Users:Berries', js: true do
  scenario 'visting top users by berries will display top users' do
    restaurant_comment = FactoryBot.create(:restaurant_comment)
    another_comment = FactoryBot.create(:restaurant_comment).comment
    comment = restaurant_comment.comment
    author = comment.user
    another_author = comment.user
    2.times { FactoryBot.create(:content_berry, comment: comment) }
    FactoryBot.create(:content_berry, comment: another_comment)

    visit top_users_berries_path

    top_user = all('h3.ui.header').first

    expect(page).to have_text('Top Users')
    expect(page).to have_text(author.name)
    expect(page).to have_text(another_author.name)
    expect(top_user).to have_text(author.name)
  end
end

