require 'rails_helper'

RSpec.describe PdfParser, type: :model do
  let(:item_listing) { FactoryGirl.create(:item_listing, parse_options: {"split_regex" => '^(.*?)\\:$'}) }

  subject { PdfParser.new() }

  before do
    subject.instance_variable_set(:@item_listing, item_listing)
  end

  describe '#seperate_items_from_ingredients' do
    context 'scan_regex' do
      let(:item_listing) { FactoryGirl.create(:item_listing, parse_options: {"scan_regex" => '^([A-Z].*?)\s\s+(?:[A-Z])'}) }
      let(:parser) { PdfParser.new() }
      let(:data) { "Apple Chunks/Apple Slices      Apples, calcium ascorbate (to maintain freshness and colour).\nApple Pecan Salad Blend        Iceberg lettuce, romaine lettuce, spring mix (baby lettuces [red & green romaine, red & green oak, red & green\n\n                               leaf, lolla rosa, tango], spinach, mizuna arugula, tatsoi, red chard, green chard), apple chunks (apples, calcium\n                               ascorbate), dried cranberries (cranberries, sugar, sunflower oil)." }

      it 'scan_regex' do
        parser.instance_variable_set(:@item_listing, item_listing)

        expected = ['Apple Chunks/Apple Slices',
                    'Apples, calcium ascorbate (to maintain freshness and colour).',
                    'Apple Pecan Salad Blend',
                    'Iceberg lettuce, romaine lettuce, spring mix (baby lettuces [red & green romaine, red & green oak, red & green leaf, lolla rosa, tango], spinach, mizuna arugula, tatsoi, red chard, green chard), apple chunks (apples, calcium ascorbate), dried cranberries (cranberries, sugar, sunflower oil)']
        actual = parser.seperate_items_from_ingredients data

        expect(actual).to eq expected
      end
    end

    context 'split_regex' do
      let(:data) {"\nARTISAN ROLL:\nIngredients: Wheat Flour or Enriched Flour (Wheat Flour or Bleached Wheat Flour, Niacin, Iron, Thiamine Mononitrate, Riboflavin, Folic Acid), Malted Barley Flour,\n\nWater, Sugar, Yeast, Palm Oil, Wheat Gluten, Dextrose, Salt, Contains 2% or less: Natural Flavors (Plant Source), Corn Flour, Soybean Oil, Calcium Sulfate, Mono-\nand Diglycerides, Sodium Stearoyl Lactylate, Monocalcium Phosphate, Ascorbic Acid, Enzymes, Calcium Propionate (Preservative), Vegetable Proteins (Pea, Potato,\n\nRice), Sunflower Oil, Turmeric, Paprika, Corn Starch, Wheat Starch, Acetic Acid.\nCONTAINS: WHEAT." }

      it 'yolo' do
        expected = ['ARTISAN ROLL',
                    'Wheat Flour or Enriched Flour (Wheat Flour or Bleached Wheat Flour, Niacin, Iron, Thiamine Mononitrate, Riboflavin, Folic Acid), Malted Barley Flour, Water, Sugar, Yeast, Palm Oil, Wheat Gluten, Dextrose, Salt, Contains 2% or less: Natural Flavors (Plant Source), Corn Flour, Soybean Oil, Calcium Sulfate, Mono-and Diglycerides, Sodium Stearoyl Lactylate, Monocalcium Phosphate, Ascorbic Acid, Enzymes, Calcium Propionate (Preservative), Vegetable Proteins (Pea, Potato, Rice), Sunflower Oil, Turmeric, Paprika, Corn Starch, Wheat Starch, Acetic Acid.CONTAINS: WHEAT.']
        actual = subject.seperate_items_from_ingredients data

        expect(actual).to eq expected
      end
    end
  end

  describe '#parse' do
    let(:item_string) { "\nARTISAN ROLL:\nIngredients: Wheat Flour or Enriched Flour (Wheat Flour or Bleached Wheat Flour, Niacin, Iron, Thiamine Mononitrate, Riboflavin, Folic Acid), Malted Barley Flour,\n\nWater, Sugar, Yeast, Palm Oil, Wheat Gluten, Dextrose, Salt, Contains 2% or less: Natural Flavors (Plant Source), Corn Flour, Soybean Oil, Calcium Sulfate, Mono-\nand Diglycerides, Sodium Stearoyl Lactylate, Monocalcium Phosphate, Ascorbic Acid, Enzymes, Calcium Propionate (Preservative), Vegetable Proteins (Pea, Potato,\n\nRice), Sunflower Oil, Turmeric, Paprika, Corn Starch, Wheat Starch, Acetic Acid.\nCONTAINS: WHEAT." }

    before do
      item_listing.update(filename: 'something.pdf')
    end

    it 'parses the item listing' do
      allow(subject).to receive(:extract_document_text) { item_string }

      actual = subject.parse(item_listing)

      expected = ['ARTISAN ROLL', 'Wheat Flour or Enriched Flour (Wheat Flour or Bleached Wheat Flour, Niacin, Iron, Thiamine Mononitrate, Riboflavin, Folic Acid), Malted Barley Flour, Water, Sugar, Yeast, Palm Oil, Wheat Gluten, Dextrose, Salt, Contains 2% or less: Natural Flavors (Plant Source), Corn Flour, Soybean Oil, Calcium Sulfate, Mono-and Diglycerides, Sodium Stearoyl Lactylate, Monocalcium Phosphate, Ascorbic Acid, Enzymes, Calcium Propionate (Preservative), Vegetable Proteins (Pea, Potato, Rice), Sunflower Oil, Turmeric, Paprika, Corn Starch, Wheat Starch, Acetic Acid.CONTAINS: WHEAT.' ]

      expect(actual).to eq expected
    end
  end

  describe '#extract_relevant_data' do
    let(:start_str) { 'Some Header' }
    let(:end_str) { 'Some Closer' }
    let(:item_str) { "\nARTISAN ROLL:\nIngredients: Wheat Flour or Enriched Flour" }
    let(:parsed_text) { "#{start_str} #{ item_str} #{end_str}" }

    before do
      item_listing.update(filename: 'something.pdf')
    end

    it 'extracts only the text inbetween the START and END strings' do

      actual = subject.extract_relevant_data(parsed_text, start_str, end_str)

      expect(actual).to eq item_str + ' '
    end

    it 'extracts only the text before the END string' do

      actual = subject.extract_relevant_data(parsed_text, nil, end_str)

      expect(actual).to eq (parsed_text.remove end_str)
    end

    it 'extracts only the text after the START string' do

      actual = subject.extract_relevant_data(parsed_text, start_str, nil)

      expect(actual).to eq (parsed_text.remove start_str + ' ')
    end
  end

  describe '#use_scan_to_seperate' do
    let(:parsed_data) { "Apple Chunks/Apple Slices      Apples, calcium ascorbate (to maintain freshness and colour).\nApple Pecan Salad Blend        Iceberg lettuce, romaine lettuce, spring mix (baby lettuces [red & green romaine, red & green oak, red & green\n\n                               leaf, lolla rosa, tango], spinach, mizuna arugula, tatsoi, red chard, green chard), apple chunks (apples, calcium\n                               ascorbate), dried cranberries (cranberries, sugar, sunflower oil)." }

    it 'scans stuff' do
      regex = Regexp.new '^([A-Z].*?)\s\s+(?:[A-Z])'

      actual = subject.use_scan_to_seperate(parsed_data, regex)

      expect(actual[0]).to include 'Apple Chunks/Apple Slices'
      expect(actual[1]).to include "Apples, calcium ascorbate (to maintain freshness and colour)."
      expect(actual[2]).to include "Apple Pecan Salad Blend"
      expect(actual[3]).to include "Iceberg lettuce, romaine lettuce, spring mix (baby lettuces [red & green romaine, red & green oak, red & green leaf, lolla rosa, tango], spinach, mizuna arugula, tatsoi, red chard, green chard), apple chunks (apples, calcium ascorbate), dried cranberries (cranberries, sugar, sunflower oil)"
    end
  end
end
