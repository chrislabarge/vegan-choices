# frozen_string_literal: true
module ApplicationHelper
  def image_path(object)
    object.image_path || 'no-img.jpeg'
  end

  def body_class
    @body_class || nil
  end

  def flash_class(level)
    case level.to_sym
    when :success then 'ui green message'
    when :error then 'ui red message'
    when :warning then 'ui yellow message'
    when :notice then 'ui blue message'
    end
  end


  # refactor the crap out of this
  # def display_messages
  #   content = ''

  #   flash.each do |key, value|
  #     content += "<div class='#{flash_class(key)} close'>"
  #     content += '<i class=" close icon">'
  #     content += value
  #     if key == 'error'
  #       @model.errors.messages.each do |attr, messages|
  #         if messages.present?
  #           content += attr.to_s
  #           %ul
  #             - messages.each do |msg|
  #               %li
  #                 = "#{attr.to_s.titleize} #{msg}"

  # end
end
