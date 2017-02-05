# frozen_string_literal: true
module ApplicationHelper
  def image_path(object)
    object.image_path || 'no-img.jpeg'
  end

  def flash_class(level)
    case level.to_sym
    when :success then 'ui green message'
    when :error then 'ui red message'
    when :warning then 'ui yellow message'
    when :notice then 'ui blue message'
    end
  end
end
