class Location < ApplicationRecord
  #EVETUNALLY GET RID OF THE STATE CLASSS AND THIS LINE BELOW
  belongs_to :state_model, class_name: "State", foreign_key: :state_id

  belongs_to :restaurant, inverse_of: :locations
  belongs_to :user, inverse_of: :locations

  # validates :city, presence: true, uniqueness: { scope: :state_id,
  #                                                case_sensitive: false }
end
