require 'rails_helper'

feature 'Reports:ReportRestaurant', js: true do
  scenario 'a user reports a restaurant' do
    FactoryGirl.create(:report_reason, name: ReportReason::INAPPROPRIATE)
    user = FactoryGirl.create(:user)
    creator = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: creator)
    additional_info = 'restaurant is breaking the rules of condition'
    report_count = Report.count
    report_restaurant_count = ReportRestaurant.count

    authenticate(user)

    visit restaurant_path(restaurant)

    click_link 'Report Restaurant'

    select_reason()

    fill_in 'Additional Information', with: additional_info

    click_button "Send Report"

    expect(page).to have_text('Thank you for reporting the restaurant.')
    expect(page).to have_text('We will be looking into this.')
    expect(Report.count).to eq report_count + 1
    expect(ReportRestaurant.count).to eq report_restaurant_count + 1
    expect(creator.report_restaurants.present?).to eq true
  end

  scenario 'a visitor cannot report a restaurant' do
    restaurant = FactoryGirl.create(:restaurant)

    visit restaurant_path(restaurant)

    click_link 'Report Restaurant'

    expect(page).not_to have_text("Report Restaurant")
    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def select_reason
  find('.ui.dropdown').click
  find('.menu.visible .item').click
end
