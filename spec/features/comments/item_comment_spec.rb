require 'rails_helper'

feature 'Comments:CreateComment', js: true do
  scenario 'a user creates a comment' do
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item)
    restaurant = item.restaurant
    content = 'This is the comment content'

    authenticate(user)

    visit restaurant_path(restaurant)

    drop_accordian()

    click_link 'Add Comment'

    fill_in 'Content', with: content

    click_button "Submit"

    expect(page).to have_text(content)
  end

  scenario 'a user edits their comment' do
    content = 'some edited content'
    item_comment =  FactoryGirl.create(:item_comment)
    item = item_comment.item
    comment = item_comment.comment
    user = comment.user

    authenticate(user)

    visit comments_item_path(item)

    click_link 'Edit Comment'

    fill_in 'Content', with: content

    click_button "Update Comment"

    expect(page).to have_text(content)
    expect(page).to have_text('Successfully updated your comment.')
  end

  scenario 'a user edits another users comment' do
    content = 'some edited content'
    item_comment =  FactoryGirl.create(:item_comment)
    item = item_comment.item
    comment = item_comment.comment
    user = FactoryGirl.create(:user)

    authenticate(user)

    visit edit_item_comment_path(item_comment)

    expect_forbidden_error_page
  end

  scenario 'a user deletes another users comment' do
    # TODO: Dont know how to send a delete request with poltergiest at the moment.
  end

  scenario 'a user creates another users comment' do
    # TODO: YOu dont even need to test this because there is no way someone could create another persons comment the way I have it.
  end

  scenario 'a user deletes their comment' do
    item_comment =  FactoryGirl.create(:item_comment)
    item = item_comment.item
    comment = item_comment.comment
    user = comment.user
    content = comment.content

    authenticate(user)

    visit comments_item_path(item)

    click_link 'Delete Comment'

    accept_alert

    expect(page).not_to have_text(content)
    expect(page).to have_text('Successfully deleted your comment.')
  end

  scenario 'a user replies to a comment' do
    # have the logic for the user to reply
  end

end

def drop_accordian
  all('.content.ui.accordion').first.click
end

