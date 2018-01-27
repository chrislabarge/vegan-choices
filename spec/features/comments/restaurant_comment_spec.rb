require 'rails_helper'

feature 'Comments:CreateComment', js: true do
  scenario 'a user creates a comment' do
    user = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant)
    content = 'This is the comment content'

    authenticate(user)

    visit restaurant_path(restaurant)

    find('.comment.icon').trigger('click')

    sleep(1)

    fill_in 'Content', with: content

    click_button 'Create Comment'

    berry_toggle = within('#comments') { find('.berry .icon.popup')['data-content'] }

    expect(page).to have_text(content)
    expect(berry_toggle).to eq("Remove Berry")
  end

  scenario 'a user edits their comment' do
    content = 'some edited content'
    restaurant_comment =  FactoryBot.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment
    user = comment.user

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    find('.edit-comment i').trigger('click')

    fill_in 'Content', with: content

    click_button "Update Comment"

    expect(page).to have_text(content)
    expect(page).to have_text('Successfully updated your comment.')
  end

  scenario 'a user edits another users comment' do
    restaurant_comment =  FactoryBot.create(:restaurant_comment)
    comment = restaurant_comment.comment
    user = FactoryBot.create(:user)

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
    restaurant_comment =  FactoryBot.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment
    user = comment.user
    content = comment.content

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    find('.delete-comment i').trigger('click')

    accept_alert

    expect(page).not_to have_text(content)
    expect(page).to have_text('Successfully deleted your comment.')
  end

  scenario 'a user replies to a comment' do
    restaurant_comment =  FactoryBot.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment
    user = FactoryBot.create(:user)
    reply = "This is a reply"

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    find('.reply-comment i').trigger('click')

    fill_in 'Content', with: reply

    click_button "Create Comment"

    comment_icon = find('.user-options > .comment')

    expect(page).to have_text('Successfully created comment reply.')
    expect(page).to have_text(reply)
    expect(comment_icon).to have_text('2')
  end

  scenario 'a user removes their reply' do
    restaurant_comment =  FactoryBot.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment
    reply_comment = FactoryBot.create(:reply_comment, reply_to: comment)
    user = reply_comment.comment.user
    comment_count = Comment.count

    authenticate(user)

    visit comments_restaurant_path(restaurant)

    within all('.restaurant-list').last do
      find('.delete-comment i').trigger('click')
    end

    expect(page).to have_text('Successfully deleted your comment.')
    expect(Comment.count).to eq comment_count - 1
  end

  scenario 'a user cannot edit or delete another users comment' do
    restaurant_comment =  FactoryBot.create(:restaurant_comment)
    user = FactoryBot.create(:user)

    authenticate(user)

    visit comments_restaurant_path(restaurant_comment.restaurant)

    expect(page).not_to have_text('Edit')
    expect(page).not_to have_text('Delete')
  end

  scenario 'a user cannot reply to their own comment comment' do
    restaurant_comment =  FactoryBot.create(:restaurant_comment)
    user = restaurant_comment.user

    authenticate(user)

    visit comments_restaurant_path(restaurant_comment.restaurant)

    expect(page).not_to have_text('Reply')
  end

  scenario 'a visitor cannot edit or deletes' do
    restaurant_comment = FactoryBot.create(:restaurant_comment)
    restaurant = restaurant_comment.restaurant
    comment = restaurant_comment.comment

    FactoryBot.create(:reply_comment, reply_to: comment)

    visit comments_restaurant_path(restaurant)

    expect(page).not_to have_text("Edit")
    expect(page).not_to have_text("Delete")
  end
end

def drop_accordian
  all('.content.ui.accordion').first.click
end

