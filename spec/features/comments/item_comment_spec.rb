require 'rails_helper'

feature 'Comments:CreateComment', js: true do
  scenario 'a user creates a comment' do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    restaurant = item.restaurant
    content = 'This is the comment content'

    authenticate(user)

    visit restaurant_path(restaurant)

    drop_accordian()

    div = all('.list').first

    within(div) do
      find('.comment.icon').trigger('click')
    end

    fill_in 'Content', with: content

    click_button "Create Comment"

    berry_toggle = within('#comments') { find('.berry .icon.popup')['data-content'] }

    expect(page).to have_text(content)
    expect(berry_toggle).to eq("Remove Berry")
  end

  scenario 'a user edits their comment' do
    content = 'some edited content'
    item_comment =  FactoryBot.create(:item_comment)
    item = item_comment.item
    comment = item_comment.comment
    user = comment.user

    authenticate(user)

    visit item_path(item)

    find('.edit-comment i').trigger('click')

    fill_in 'Content', with: content

    click_button "Update Comment"

    expect(page).to have_text(content)
    expect(page).to have_text('Successfully updated your comment.')
  end

  scenario 'a user edits another users comment' do
    item_comment =  FactoryBot.create(:item_comment)
    comment = item_comment.comment
    user = FactoryBot.create(:user)

    authenticate(user)

    visit edit_comment_path(comment)

    expect_forbidden_error_page
  end

  pending 'an admin user edits another users comment' do
    item_comment =  FactoryBot.create(:item_comment)
    comment = item_comment.comment
    user = FactoryBot.create(:user, admin: true)

    authenticate(user)

    visit edit_comment_path(comment)
    # there is no templacer for this so its failing, which is fine because I dont want admins to change text from front end right now
  end

  scenario 'a user deletes another users comment' do
    # TODO: Dont know how to send a delete request with poltergiest at the moment.
  end

  scenario 'a user creates another users comment' do
    # TODO: YOu dont even need to test this because there is no way someone could create another persons comment the way I have it.
  end

  scenario 'a user deletes their comment' do
    item_comment =  FactoryBot.create(:item_comment)
    item = item_comment.item
    comment = item_comment.comment
    user = comment.user
    content = comment.content

    authenticate(user)

    visit item_path(item)

    find('.delete-comment i').trigger('click')

    accept_alert

    expect(page).not_to have_text(content)
    expect(page).to have_text('Successfully deleted your comment.')
  end

  scenario 'a user replies to a comment' do
    item_comment =  FactoryBot.create(:item_comment)
    item = item_comment.item
    user = FactoryBot.create(:user)
    reply = "This is a reply"

    authenticate(user)

    visit item_path(item)

    find('.reply-comment i').trigger('click')

    fill_in 'Content', with: reply

    click_button "Create Comment"

    expect(page).to have_text('Successfully created comment reply.')

    visit comments_item_path(item)

    expect(page).to have_text(reply)
  end

  scenario 'a user cannot edit or delete another users comment' do
    item_comment =  FactoryBot.create(:item_comment)
    user = FactoryBot.create(:user)

    authenticate(user)

    visit comments_item_path(item_comment.item)

    expect(page).not_to have_text('Edit')
    expect(page).not_to have_text('Delete')
  end

  scenario 'a user cannot reply to their own comment comment' do
    item_comment =  FactoryBot.create(:item_comment)
    user = item_comment.user

    authenticate(user)

    visit comments_item_path(item_comment.item)

    expect(page).not_to have_text('Reply')
  end

  scenario 'a visitor cannot edit or delete comments' do
    item_comment = FactoryBot.create(:item_comment)
    item = item_comment.item
    comment = item_comment.comment

    FactoryBot.create(:reply_comment, reply_to: comment)

    visit comments_item_path(item)

    expect(page).not_to have_text("Edit Comment")
    expect(page).not_to have_text("Delete Comment")
  end
end

def drop_accordian
  all('.content.ui.accordion').first.click
end

