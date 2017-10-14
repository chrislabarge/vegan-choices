class ReportComment < ApplicationRecord
  belongs_to :comment
  belongs_to :report_reason
  belongs_to :report

  scope :reports, -> { joins(:report) }


  accepts_nested_attributes_for :report

  def self.reasons
   [ReportReason.send(ReportReason::INAPPROPRIATE),
    ReportReason.send(ReportReason::TROLL),
    ReportReason.send(ReportReason::SPAM),
    ReportReason.send(ReportReason::OTHER)].compact
  end
end
