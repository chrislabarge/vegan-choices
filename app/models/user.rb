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

  def omni_authenticated?
    self.uid.present? && self.provider.present?
  end
end
