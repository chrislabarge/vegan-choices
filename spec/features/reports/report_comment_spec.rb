require 'rails_helper'

feature 'Reports:ReportComment', js: true do
  scenario 'a user reports a comment' do
    FactoryBot.create(:report_reason, name: ReportReason::INAPPROPRIATE)
    user = FactoryBot.create(:user)
    restaurant_comment = FactoryBot.create(:restaurant_comment)
    additional_info = 'Comment is breaking the rules of condition'
    report_count = Report.count
    report_comment_count = ReportComment.count

    authenticate(user)

    visit restaurant_path(restaurant_comment.restaurant)

    within('#comments') do
      find('.report-comment a').trigger('click')
    end

    select_reason()

    fill_in 'Additional Information', with: additional_info

    click_button "File Report"

    expect(page).to have_text('Thank you for reporting the comment.')
    expect(page).to have_text('We will be looking into this.')
    expect(Report.count).to eq report_count + 1
    expect(ReportComment.count).to eq report_comment_count + 1
  end

  scenario 'a user cannot report himself' do
    restaurant_comment = FactoryBot.create(:restaurant_comment)
    user = restaurant_comment.user

    authenticate(user)

    visit restaurant_path(restaurant_comment.restaurant)

    actual = within('#comments') { all('.report-comment a') }

    expect(actual).to be_empty
  end

    pending 'a visitor cannot report a comment' do

      restaurant_comment = FactoryBot.create(:restaurant_comment)

      visit comments_restaurant_path(restaurant_comment.restaurant)

      click_link 'Report'
      sleep(1)
      expect(page).to have_text("You need to sign in or sign up before continuing.")
    end
end

def select_reason
  find('.ui.dropdown').click
  find('.menu.visible .item').click
end
