class Location < ApplicationRecord
  #TODO: EVETUNALLY GET RID OF THE STATE CLASSS AND THIS LINE BELOW
  belongs_to :state_model, class_name: "State", foreign_key: :state_id

  belongs_to :restaurant, inverse_of: :locations
  belongs_to :user, inverse_of: :locations

  geocoded_by :address
  before_validation :geocode, if: -> { geocode? }

  def address_changed?
    country_changed? || state_changed? || city_changed?
  end

  def address
    [country, state, city].compact.join(',')
  end

  private

  def geocode?
    return true if !self.persisted? &&
                    address.present? &&
                    longitude.nil? &&
                    latitude.nil?

    self.persisted? && address_changed?
  end
end
