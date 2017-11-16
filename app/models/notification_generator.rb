class NotificationGenerator
  def initialize(model, options = {})
    @model = model
    @resource = options[:resource] || @model.model_name.i18n_key
    (@users = options[:users]) || @user = options[:user]
  end

  def comment_content_berry_msg
    "Someone gave you a berry for adding the comment - \"#{@model.comment.preview}...\""
  end

  def item_content_berry_msg
    "Someone gave you a berry for adding the food item #{@model.item.name} to #{@model.item.restaurant.name}"
  end

  def restaurant_content_berry_msg
    "Someone gave you a berry for adding #{@model.restaurant.name}."
  end

  def restaurant_comment_msg
    "Someone commented on the restaurant you added #{@model.restaurant.name}"
  end

  def item_comment_msg
    "Someone commented on the food item you added #{@model.item.name} to #{@model.item.restaurant.name}"
  end

  def reply_comment_msg
    "Someone replied to your comment - \"#{@model.reply_to.preview}...\""
  end

  def item_msg
    "Someone added a new food item to #{@model.restaurant.name}"
  end

  def favorite_restaurant_item_msg
    "Someone added a new food item to your favorite restaurant #{@model.restaurant.name}"
  end

  def favorite_item_comment_msg
    "Someone commented on your favorite restaurant item #{@model.item.name}"
  end

  def title(resource = nil)
    resource = resource || @resource

    return 'New Berry' if resource == :content_berry
    return 'New Item' if resource == :item
    return 'New Comment Reply' if resource == :reply_comment
    return 'New Comment' if resource.slice('comment') == 'comment'
  end

  def message
    return blast_message if @users
    return individual_message if @user
  end

  def blast_message
    if @resource == :item
      favorite_restaurant_item_msg
    else
      send("favorite_#{@resource}_msg")
    end
  end

  def individual_message
    method = "#{@resource}_msg"

    if (type = @model.try(:type))
      method = "#{type}_" + method
    end

    try(:send, method)
  end

  def generate
    users = @users || [@user]

    users.each do |user|
      create_notification(user)
    end
  end

  def create_notification(user)
    Notification.create(user: user,
                        resource: @resource,
                        resource_id: @model.id,
                        title: title,
                        message: message)
  end
end
