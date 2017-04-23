# frozen_string_literal: true
# Restaurant
class Restaurant < ApplicationRecord
  include PathNames
  include PgSearch

  pg_search_scope :search, against: :name,
                           using: {
                             tsearch: { prefix: true, dictionary: 'english' }
                           }

  has_many :item_listings, inverse_of: :restaurant
  has_many :items, inverse_of: :restaurant
  has_many :item_diets, through: :items
  has_many :item_ingredients, through: :items
  has_many :diets, through: :items

  validates :name, presence: true, uniqueness: true

  after_create :create_image_dir
  after_save :update_image_dir, :no_image_file_notification

  def generate_items
    generator = ItemGenerator.new(self)

    transaction do
      new_items = generator.generate

      items.each(&:destroy)
      new_items.each(&:save)
    end
  end

  def items_by_type(items = nil)
    items ||= self.items
    items.order(:item_type_id).group_by(&:item_type)
  end

  def menu_items
    items.menu
  end

  def non_menu_items
    items.non_menu
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
