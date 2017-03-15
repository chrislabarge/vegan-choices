require 'capybara/poltergeist'

class WebScraper
  def initialize
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false, js: true)
    end

    Capybara.ignore_hidden_elements = false
    Capybara.default_driver = :poltergeist
  end

  def scrape(url, instructions = nil)
    instructions ||= default_instructions
    browser = generate_new_browser_session

    begin
      browser.visit url
      sleep(1)

      results = instructions.call(browser)
    ensure
      browser.driver.quit
    end

    results
  end

  def default_instructions
    ->(scraper) { scraper.html }
  end

  def generate_new_browser_session
    Capybara::Session.new(:poltergeist)
  end
end
