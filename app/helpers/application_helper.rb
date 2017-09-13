# frozen_string_literal: true
module ApplicationHelper
  def image_path(object)
    object.image_path || 'default/no-img'
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
    when :alert then 'ui yellow message'
    end
  end

  def display_title
    prefix = @app_name
    suffix = (@html_title ? (' - ' + @html_title) : '')
    prefix + suffix
  end

  def display_description
    @html_description || default_description
  end

  def default_description
    "Use #{@app_name} to search for restaurants that have animal free products."
  end

  def menu_item_count(restaurant)
    items = restaurant.menu_items
    count_items(items)
  end

  def non_menu_item_count(restaurant)
    items = restaurant.non_menu_items
    count_items(items)
  end

  def count_items(items)
    if @diet
      scope = @diet.name
      items = items.send(scope)
    end

    items.count
  end
end
