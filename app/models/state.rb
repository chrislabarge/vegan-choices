class State < ApplicationRecord
  has_many :locations, inverse_of: :state
end
