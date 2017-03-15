require 'rails_helper'

RSpec.describe WebScraper, type: :model do
  subject { WebScraper.new() }

  # describe '#seperate_items_from_ingredients' do

  #   #Make sure modules were required
  # end

  describe '#scrape' do
    let(:url)  { 'http://www.example.com' }
    let(:instructions) { ->(x) { puts 'block called' } }
    let(:browser)  { double(:browser) }

    before do
      allow(subject).to receive(:generate_new_browser_session) { browser }
      allow(browser).to receive(:visit).with(url) {}
      allow(browser).to receive(:html)
      allow(instructions).to receive(:call).with(browser)
    end

    it 'returns the html of the passed url' do
      subject.scrape(url)

      expect(subject).to have_received(:generate_new_browser_session)
      expect(browser).to have_received(:visit).with(url) {}
      expect(browser).to have_received(:html)
      expect(instructions).not_to have_received(:call).with(browser)
    end

    it 'follows the scrape instructions' do
      subject.scrape(url, instructions)

      expect(subject).to have_received(:generate_new_browser_session)
      expect(browser).to have_received(:visit).with(url) {}
      expect(browser).not_to have_received(:html)
      expect(instructions).to have_received(:call).with(browser)
    end
  end

  describe '#follow_scrape_instructions' do
    let(:url)  { 'https://www.dunkindonuts.com/en/food-drinks/sandwiches-wraps' }
    # let(:instructions) {
    #                      [
    #                       [ :fill_in, ['Email or Phone', {with: 'clabvessels@gmail.com'}]],
    #                       [ :fill_in, ['Password', {with: 'bitetobreakskin'}]],
    #                       [ :click_on, ['Log In']],
    #                       [ :find, [:xpath, "//a[@href='/login/save-device/cancel/']"], :trigger, ['click'] ],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, ['window.scroll(0,1000);']],
    #                       # [ :execute_script, [%Q{$("#viewport").prop("scrollTop", 1000000).trigger('scroll')}]],
    #                       [ :save_screenshot, ['feed.png', full: true]]
    #                      ]
    #                    }


    # let(:instructions) { ->(browser) {
    #        browser.click_on('Egg & Cheese')
    #        sleep(1)
    #        puts browser.html
    # } }

    it 'invokes the instruction methods on the browser session' do
    #   instructions = ~>(browser) {
    #        browser.click_on('Egg & Cheese')
    #        puts browser.html
    # }
      # subject.scrape(url, instructions)
    end
  end


  # describe '#extract_relevant_data' do
  #   let(:start_str) { 'Some Header' }
  #   let(:end_str) { 'Some Closer' }
  #   let(:item_str) { "\nARTISAN ROLL:\nIngredients: Wheat Flour or Enriched Flour" }
  #   let(:parsed_text) { "#{start_str} #{ item_str} #{end_str}" }

  #   before do
  #     item_listing.update(filename: 'something.pdf')
  #   end

  #   it 'extracts only the text inbetween the START and END strings' do

  #     actual = subject.extract_relevant_data(parsed_text, start_str, end_str)

  #     expect(actual).to eq item_str + ' '
  #   end

  #   it 'extracts only the text before the END string' do

  #     actual = subject.extract_relevant_data(parsed_text, nil, end_str)

  #     expect(actual).to eq (parsed_text.remove end_str)
  #   end

  #   it 'extracts only the text after the START string' do

  #     actual = subject.extract_relevant_data(parsed_text, start_str, nil)

  #     expect(actual).to eq (parsed_text.remove start_str + ' ')
  #   end
  # end

  # describe '#scan' do
  #   let(:parsed_data) { "Apple Chunks/Apple Slices      Apples, calcium ascorbate (to maintain freshness and colour).\nApple Pecan Salad Blend        Iceberg lettuce, romaine lettuce, spring mix (baby lettuces [red & green romaine, red & green oak, red & green\n\n                               leaf, lolla rosa, tango], spinach, mizuna arugula, tatsoi, red chard, green chard), apple chunks (apples, calcium\n                               ascorbate), dried cranberries (cranberries, sugar, sunflower oil)." }

  #   # before do
  #   #   item_listing.update(filename: 'something.pdf')
  #   # end

  #   it 'scans stuff' do
  #     regex = Regexp.new '^([A-Z].*?)\s\s+(?:[A-Z])'

  #     actual = subject.scan_test(parsed_data, regex)

  #     expect(actual[0]).to include 'Apple Chunks/Apple Slices'
  #     expect(actual[1]).to include "Apples, calcium ascorbate (to maintain freshness and colour)."
  #     expect(actual[2]).to include "Apple Pecan Salad Blend"
  #     expect(actual[3]).to include "Iceberg lettuce, romaine lettuce, spring mix (baby lettuces [red & green romaine, red & green oak, red & green leaf, lolla rosa, tango], spinach, mizuna arugula, tatsoi, red chard, green chard), apple chunks (apples, calcium ascorbate), dried cranberries (cranberries, sugar, sunflower oil)"

  #     # expect(actual).to eq [ "Apple Chunks/Apple Slices", "Apples, calcium ascorbate (to maintain freshness and colour).", "Apple Pecan Salad Blend", "Iceberg lettuce, romaine lettuce, spring mix (baby lettuces [red & green romaine, red & green oak, red & green\n\n leaf, lolla rosa, tango], spinach, mizuna arugula, tatsoi, red chard, green chard), apple chunks (apples, calcium ascorbate), dried cranberries (cranberries, sugar, sunflower oil)." ]
  #   end

    # it 'extracts only the text before the END string' do

    #   actual = subject.extract_relevant_data(parsed_text, nil, end_str)

    #   expect(actual).to eq (parsed_text.remove end_str)
    # end

    # it 'extracts only the text after the START string' do

    #   actual = subject.extract_relevant_data(parsed_text, start_str, nil)

    #   expect(actual).to eq (parsed_text.remove start_str + ' ')
    # end
  # end
end
