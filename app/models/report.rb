class Report < ApplicationRecord
  belongs_to :user, inverse_of: :reports
  has_one :report_comment, inverse_of: :report

  scope :report_comments, -> { joins(:report_comment) }
end
