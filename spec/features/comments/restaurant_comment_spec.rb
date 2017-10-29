require 'rails_helper'

feature 'Comments:CreateComment', js: true do
  scenario 'a user creates a comment' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant)
    content = 'This is the comment content'

    authenticate(user)

    visit restaurant_path(restaurant)

    click_link 'Add Comment'

    fill_in 'Content', with: content

    click_button "Create Comment"

    expect(page).to have_text(content)
  end

  scenario 'a user edits their comment' do
    content = 'some edited content'
    restaurant_comment =  FactoryGirl.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment
    user = comment.user

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    click_link 'Edit Comment'

    fill_in 'Content', with: content

    click_button "Update Comment"

    # expect(page).to have_text(content)
    expect(page).to have_text('Successfully updated your comment.')
  end

  scenario 'a user edits another users comment' do
    restaurant_comment =  FactoryGirl.create(:restaurant_comment)
    comment = restaurant_comment.comment
    user = FactoryGirl.create(:user)

    authenticate(user)

    visit edit_comment_path(comment)

    expect_forbidden_error_page
  end

  scenario 'a user deletes another users comment' do
    # TODO: Dont know how to send a delete request with poltergiest at the moment.
  end

  scenario 'a user creates another users comment' do
    # TODO: YOu dont even need to test this because there is no way someone could create another persons comment the way I have it.
  end

  scenario 'a user deletes their comment' do
    restaurant_comment =  FactoryGirl.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment
    user = comment.user
    content = comment.content

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    click_link 'Delete Comment'

    accept_alert

    expect(page).not_to have_text(content)
    expect(page).to have_text('Successfully deleted your comment.')
  end

  scenario 'a user replies to a comment' do
    restaurant_comment =  FactoryGirl.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment
    user = FactoryGirl.create(:user)
    reply = "This is a reply"

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    click_on 'Reply'

    fill_in 'Content', with: reply

    click_button "Create Comment"

    expect(page).to have_text('Successfully created comment reply.')

    visit comments_restaurant_path(restaurant)

    expect(page).to have_text(reply)
  end

  scenario 'a user cannot edit or delete another users comment' do
    restaurant_comment =  FactoryGirl.create(:restaurant_comment)
    user = FactoryGirl.create(:user)

    authenticate(user)

    visit comments_restaurant_path(restaurant_comment.restaurant)

    expect(page).not_to have_text('Edit Comment')
    expect(page).not_to have_text('Delete Comment')
  end

  scenario 'a user cannot reply to their own comment comment' do
    restaurant_comment =  FactoryGirl.create(:restaurant_comment)
    user = restaurant_comment.user

    authenticate(user)

    visit comments_restaurant_path(restaurant_comment.restaurant)

    expect(page).not_to have_text('Reply')
  end

  scenario 'a visitor cannot edit or delete comments' do
    restaurant_comment = FactoryGirl.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment

    FactoryGirl.create(:reply_comment, reply_to: comment)

    visit comments_restaurant_path(restaurant)

    expect(page).not_to have_text("Edit Comment")
    expect(page).not_to have_text("Delete Comment")
  end
end

def drop_accordian
  all('.content.ui.accordion').first.click
end
