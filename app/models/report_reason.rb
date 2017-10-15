# frozen_string_literal: true
#ReportReason
class ReportReason < ApplicationRecord
  INAPPROPRIATE = 'inappropriate'.freeze
  TROLL = 'trolling'.freeze
  SPAM = 'spam'.freeze
  NOT_VEGAN = 'not vegan'.freeze
  MISTAKE = 'mistake'.freeze
  DUPLICATE = 'duplicate'.freeze
  OTHER = 'other'.freeze

  def self.names
    [INAPPROPRIATE,
     TROLL,
     SPAM,
     NOT_VEGAN,
     MISTAKE,
     DUPLICATE,
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
