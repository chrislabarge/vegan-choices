# frozen_string_literal: true
module RestaurantHelper
  def restaurant_sort_options
    options = Restaurant.sort_options

    content = options.map do |name, param_value|
      path = request.path + '/?sort_by=' + param_value

      link_to(name, path, class: 'item')
    end

    content.join.html_safe
  end

  def option_view_name(value)
    Restaurant.sort_options.key(value)
  end

  def locations_url(restaurant)
    maps_base_url = 'https://www.google.com/maps/search/'
    maps_base_url + restaurant.path_name
  end

  def recipe
    @recipe || nil
  end

  def header?(str)
    str.scan(/with|%/).present?
  end

  def restaurant_index_list_header_options
    options = {}
    options[:row_title] = option_view_name(@sort_by)
    options[:sortable] = true
    options[:list_options] = 'restaurants/list_options'
    options
  end

  def location?
    return unless defined?(@model)
    @model.try(:persisted?) && current_page?(restaurant_path(@model)) && @model.location
  end

  def display_location
    location = @model.location
    content =  location.try(:state)

    if location.try(:city).present?
      content = "#{location.city}, #{content}"
    end

    content
  end

  def hours?
    location? && @model.location.hours.present?
  end

  def phone?
    location? && @model.location.phone_number.present?
  end

  def format_hours(json)
    hash = JSON.parse(json)

    hash["weekday_text"].join('<br><br>')
  end

  def row_image_path(model)
    model.thumbnail || image_path(model)
  end
end
