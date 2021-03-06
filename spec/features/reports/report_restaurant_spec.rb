require 'rails_helper'

feature 'Reports:ReportRestaurant', js: true do
  scenario 'a user reports a restaurant' do
    FactoryBot.create(:report_reason, name: ReportReason::INAPPROPRIATE)
    user = FactoryBot.create(:user)
    creator = FactoryBot.create(:user)
    restaurant = FactoryBot.create(:restaurant, user: creator)
    additional_info = 'restaurant is breaking the rules of condition'
    report_count = Report.count
    report_restaurant_count = ReportRestaurant.count

    authenticate(user)

    visit restaurant_path(restaurant)

    find('.report-restaurant a').trigger('click')

    select_reason()

    fill_in 'Additional Information', with: additional_info

    click_button "File Report"

    expect(page).to have_text('Thank you for reporting the restaurant.')
    expect(page).to have_text('We will be looking into this.')
    expect(Report.count).to eq report_count + 1
    expect(ReportRestaurant.count).to eq report_restaurant_count + 1
    expect(creator.report_restaurants.present?).to eq true
  end

  pending 'a visitor cannot report a restaurant' do
    restaurant = FactoryBot.create(:restaurant)

    visit restaurant_path(restaurant)

    click_link 'Report Restaurant'
    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def select_reason
  find('.ui.dropdown').click
  find('.menu.visible .item').click
end
