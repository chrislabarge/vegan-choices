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

  has_many :comments, inverse_of: :user, dependent: :destroy
  has_many :reports, inverse_of: :user, dependent: :destroy
  has_many :report_comments, through: :comments
  has_many :favorites, inverse_of: :user, dependent: :destroy
  has_many :favorite_restaurants, through: :favorites, source: :restaurant
  # TODO: these ones below will only work when I complete the feature to allow users to add restaurants and items
  # has_many :report_items, through: :items
  # has_many :report_restaurants, through: :restaurants

  def negative_reports
    # TODO: these ones below will only work when I complete the feature to allow users to add restaurants and items
    report_comments.map(&:report) # + report_items.map(&:report) + report_restaurants.map(&:report)
  end

  def omni_authenticated?
    self.uid.present? && self.provider.present?
  end
end
