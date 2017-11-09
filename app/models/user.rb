class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable,
         omniauth_providers: [:twitter, :google_oauth2, :facebook]

  validates :name, uniqueness: true, allow_nil: true

  has_many :notifications, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
  has_many :reports, inverse_of: :user, dependent: :destroy
  #TODO: change report_comments to report'ed'_comments
  has_many :content_berries, inverse_of: :user
  has_many :favorites, inverse_of: :user, dependent: :destroy
  has_many :favorite_restaurants, through: :favorites, source: :restaurant
  has_many :favorite_items, through: :favorites, source: :item
  has_many :favorite_users, through: :favorites, source: :profile
  has_many :following_favorites,  class_name: 'Favorite', foreign_key: 'profile_id', source: :user
  has_many :followers, through: :following_favorites, source: :user
  has_many :comments_berried, through: :content_berries, source: :comment
  has_many :items_berried, through: :content_berries, source: :item
  has_many :restaurants_berried, through: :content_berries, source: :restaurant
  has_many :restaurant_berries, through: :restaurants, source: :content_berries
  has_many :item_berries, through: :items, source: :content_berries
  has_many :comment_berries, through: :comments, source: :content_berries
  has_many :items, inverse_of: :user
  has_many :restaurants, inverse_of: :user
  has_many :report_comments, through: :comments
  has_many :report_items, through: :items
  has_many :report_restaurants, through: :restaurants

  before_destroy :administrate_content

  def berry_count
    comment_berries.count + restaurant_berries.count + item_berries.count
  end

  def negative_reports
    report_comments.map(&:report) +
    report_items.map(&:report) +
    report_restaurants.map(&:report)
  end

  def omni_authenticated?
    self.uid.present? && self.provider.present?
  end

  private

  def administrate_content()
    [items, restaurants].each do |content|
      content.each { |model| model.update(user_id: nil) }
    end
  end
end
