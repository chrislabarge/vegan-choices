# frozen_string_literal: true
module ApplicationHelper
  def image_path(object)
    object.image_path || 'no-img.jpeg'
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
    when :notice then 'ui green message'
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

  def new_comments_link(model, header: nil)
    resource = model.class.name.underscore.downcase
    attr = (resource + '_id').to_sym

    if model.comments.present?
      path = if current_page?(model)
               '#comments'
             else
               send(resource + '_path', model, anchor: 'comments')
             end

      render('comments/view_comments', path: path, model: model, header: header)
    else
      render('comments/add_comment', path: send("new_#{resource}_comment_path", attr => model.id, header: header), header: header)
    end
  end

  def resource_editable?(resource)
    current_user && current_user == resource.user
  end

  def avatar_path(model, type=nil)
    if (avatar = model.try(:avatar))
        (avatar = avatar.try(type)) if type
        path = avatar.try(:url)

      return path if path
    end

    'users/avatar.png'
  end

  def user_added_content?
    return unless defined?(@model)
    @model.persisted? && ( current_page?(restaurant_path(@model)) || current_page?(item_path(@model)) ) && @model.user
  end
end
