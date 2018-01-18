require 'rails_helper'

feature 'Notification: Delete', js: true do
  scenario 'a user deletes a notification' do
    FactoryBot.create(:item)
    notification = FactoryBot.create(:notification)
    notification.resource = 'item'
    user = notification.user

    notification.save
    authenticate(user)

    find('.notifications i.icon').click
    find('.delete-notification .submit').click

    expect(page).to have_text('Successfully removed the notification.')
    expect(page).not_to have_text(notification.title)
  end
end
