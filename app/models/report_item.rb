class ReportItem < ApplicationRecord
  belongs_to :item
  belongs_to :report
  belongs_to :report_reason

  accepts_nested_attributes_for :report

  def self.reasons
    [ReportReason::NOT_VEGAN,
     ReportReason::MISTAKE,
     ReportReason::DUPLICATE,
     ReportReason::INAPPROPRIATE,
     ReportReason::OTHER].map { |reason| ReportReason.send(reason) }.compact
  end
end
