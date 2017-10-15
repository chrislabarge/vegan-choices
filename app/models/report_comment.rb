class ReportComment < ApplicationRecord
  belongs_to :comment
  belongs_to :report_reason
  belongs_to :report

  scope :reports, -> { joins(:report) }

  accepts_nested_attributes_for :report

  def self.reasons
   [ReportReason::INAPPROPRIATE,
    ReportReason::TROLL,
    ReportReason::SPAM,
    ReportReason::OTHER].map { |reason| ReportReason.send(reason) }.compact
  end
end
