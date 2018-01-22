# frozen_string_literal: true
# Restaurant
class Restaurant < ApplicationRecord
  include PathNames
  include PgSearch
  include DefaultBerry

  pg_search_scope :search, against: :name,
                           using: {
                             tsearch: { prefix: true, dictionary: 'simple' }
                           }

  belongs_to :user, inverse_of: :restaurants
  belongs_to :location_model, class_name: "Location", foreign_key: :location_id
  has_many :locations, inverse_of: :restaurant, dependent: :destroy
  has_many :item_listings, inverse_of: :restaurant
  has_many :items, inverse_of: :restaurant
  has_many :content_berries, inverse_of: :restaurant, dependent: :destroy
  has_many :item_diets, through: :items
  has_many :item_ingredients, through: :items
  has_many :diets, through: :items
  has_many :restaurant_comments, inverse_of: :restaurant
  has_many :comments, through: :restaurant_comments
  has_many :favorites, inverse_of: :restaurant, dependent: :destroy

  has_one :report_restaurant, dependent: :destroy

  scope :report_restaurants, -> { joins(:report_restaurant) }

  validates :name, presence: true, uniqueness: true

  after_create :give_default_berry
  after_create :create_image_dir
  after_save :update_image_dir, :no_image_file_notification

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :locations, reject_if: :all_blank, allow_destroy: true

  def location
    locations.first
  end

  def generate_items
    generator = ItemGenerator.new(self)

    transaction do
      new_items = generator.generate

      items.each(&:destroy)
      new_items.each(&:save)
    end
  end

  def menu_items
    items.menu
  end

  def non_menu_items
    items.non_menu.or(items.other)
  end

  def image_path_suffix(path_name = nil)
    path_name ||= self.path_name
    "restaurants/#{path_name}/"
  end

  def image_file_name
    'logo'
  end

  def get_pepsi_beverage_item_ingredients
    scraper = PepsiBeverageScraper.new(self)

    scraper.scrape_and_set_ingredients
  end

  def generate_recipes
    generator = RecipeGenerator.new(self)

    items.each { |i| generator.generate(i) }
  end

  def self.sort_options
    { 'Most Popular' => 'content_berries',
      'By Name' => 'name' }
  end

  def thumbnail
    return unless photo_url
    photo_url[0...-3] + '180'
  end

  private

  def create_image_dir
    directory_name = image_dir
    Dir.mkdir(directory_name) unless File.directory?(directory_name)
  end

  def update_image_dir
    return unless (previous_name = changed_attributes[:name])

    previous_image_path_suffix = image_path_suffix(path_name(previous_name))
    previous_image_dir = image_dir(previous_image_path_suffix)
    new_image_dir = image_dir

    return if File.directory?(new_image_dir)

    FileUtils.mv(previous_image_dir, new_image_dir)
  end
end
