require 'rails_helper'

feature 'Reports:ReportItem', js: true do
  scenario 'a user reports a item' do
    FactoryGirl.create(:report_reason, name: ReportReason::NOT_VEGAN)
    user = FactoryGirl.create(:user)
    item = FactoryGirl.create(:item)
    additional_info = 'Item is breaking the rules of condition'
    report_count = Report.count
    report_item_count = ReportItem.count

    authenticate(user)

    visit restaurant_path(item.restaurant)

    drop_accordian

    click_link 'Report'

    select_reason()

    fill_in 'Additional Information', with: additional_info

    click_button "Send Report"

    expect(page).to have_text('Thank you for reporting the item.')
    expect(page).to have_text('We will be looking into this.')
    expect(Report.count).to eq report_count + 1
    expect(ReportItem.count).to eq report_item_count + 1
  end

  scenario 'a visitor cannot report a item' do
    item = FactoryGirl.create(:item)

    visit restaurant_path(item.restaurant)

    drop_accordian

    click_link 'Report'

    expect(page).not_to have_text("Report")
    expect(page).to have_text("You need to sign in or sign up before continuing.")
  end
end

def drop_accordian
  all('.content.ui.accordion').first.click
end

def select_reason
  find('.ui.dropdown').click
  find('.menu.visible .item').click
end
