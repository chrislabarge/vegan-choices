class Location < ApplicationRecord
  belongs_to :state, inverse_of: :locations

  has_many :restaurants, inverse_of: :location

  validates :city, presence: true, uniqueness: { scope: :state_id,
                                                 case_sensitive: false }
end
