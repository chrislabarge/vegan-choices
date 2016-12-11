require 'rails_helper'

feature 'Show: Landing Page' do
  scenario 'Visit Landing Page', js: true do
    given_a_vistor_visits_the_website
    they_should_be_shown_the_landing_page
  end

  private
  def given_a_vistor_visits_the_website
    visit '/'
  end

  def they_should_be_shown_the_landing_page
    expect_landing_page_contents
  end

  def expect_landing_page_contents
    expect(page).to have_content(ENV['APP_NAME'])
  end
end
