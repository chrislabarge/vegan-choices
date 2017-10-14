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

  def negative_reports
    #add restaurant reports eventually
    report_comments.map(&:report)
  end

  def omni_authenticated?
    self.uid.present? && self.provider.present?
  end
end
