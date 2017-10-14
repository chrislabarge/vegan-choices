# frozen_string_literal: true
#ReportReason
class ReportReason < ApplicationRecord
  INAPPROPRIATE = 'inappropriate'.freeze
  TROLL = 'trolling'.freeze
  SPAM = 'spam'.freeze
  OTHER = 'other'.freeze

  def self.names
    [INAPPROPRIATE,
     TROLL,
     SPAM,
     OTHER]
  end

  names.each do |name|
    define_singleton_method name.to_sym do
      find_by(name: name)
    end
  end

  def formatted_name
    name.titleize
  end
end
