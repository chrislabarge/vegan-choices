# frozen_string_literal: true
module ApplicationHelper
  def image_path(object)
    object.image_path || 'default/no-img'
  end

  def body_class
    @body_class || nil
  end

  def messages?
    flash.present? || devise_error_messages?
  end

  def show_messages?
    return nil unless non_form_page? &&
                  flash.present? &&
                  @model
  end

  def find_messages
    @model.try(:errors).try(:messages) || resource.try(:errors).try(:messages)
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

  def non_form_page?
    action = action_name.to_sym
    return false unless action != :create
    return false unless action != :update
    return false unless action != :delete

    true
  end

  def no_navigation_page?
    controllers = ['sessions', 'passwords']

    controllers.each do |controller|
      return true if controller_name == controller
    end

    nil
  end

  def user_logged_in?(user)
    current_user == user
  end

  def new_comments_link(model)
    resource = model.class.name.downcase
    attr = (resource + '_id').to_sym

    if model.comments.present?
      path = send("comments_#{model.class.name.underscore.downcase}_path", model)
      render('comments/view_comments', path: path, model: model)
    else
      render('comments/add_comment', path: send("new_#{resource}_comment_path", attr => model.id))
    end
  end
end
