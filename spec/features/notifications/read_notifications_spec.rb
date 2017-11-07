require 'rails_helper'

feature 'Notficiations: Viewed', js: true do
  # I am going to hold off on implementing this actually.  Not really nessasry until I have more users

  # scenario 'a notificaton gets received by the user' do
  #   creator = FactoryGirl.create(:user)
  #   restaurant = FactoryGirl.create(:restaurant, user: creator)
  #   FactoryGirl.create(:restaurant_comment, restaurant: restaurant)

  #   authenticate(creator)

  #   expect(page).to have_text("1 Notification")
  #   find('.notifications i.icon').click
  #   expect(Notification.last.received).to eq true
  # end
end
