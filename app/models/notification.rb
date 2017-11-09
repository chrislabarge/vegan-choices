class Notification < ApplicationRecord
  belongs_to :user, inverse_of: :notifications

  scope :unreceived, -> { where(received: nil) }
  scope :received, -> { where(received: true) }
end
