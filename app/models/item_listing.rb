# frozen_string_literal: true
# Ingredient List
class ItemListing < ApplicationRecord
  ITEM_LISTING_PATH = 'app/item_listing_documents/'

  store_accessor :data_extract_options

  scope :documents, -> { where.not(filename: nil) }
  scope :online, -> { where(filename: nil).where.not(url: nil) }

  belongs_to :restaurant, inverse_of: :item_listings

  alias_attribute :parse_options, :data_extract_options
  alias_attribute :scrape_options, :data_extract_options

  def pathname
    pathname = self.path || ITEM_LISTING_PATH
    "#{pathname}" + "#{filename}"
  end
end

