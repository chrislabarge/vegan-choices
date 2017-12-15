# frozen_string_literal: true
module NotificationsHelper

  def find_notification_path(notification)
    return unless (resource = notification.resource.try(:to_sym))

    case resource
    when :item
      item_path(notification.resource_id)
    when :content_berry
      content_berry_notification_path(notification.resource_id)
    when :restaurant_comment
      restaurant_path(RestaurantComment.find(notification.resource_id).restaurant, anchor: 'comments')
    when :item_comment
      item_path(ItemComment.find(notification.resource_id).item, anchor: 'comments')
    when :reply_comment
      find_comment_path(ReplyComment.find(notification.resource_id).comment)
    end
  end

  def content_berry_notification_path(id)
    berry = ContentBerry.find(id)
    type = berry.type

    case type
    when :comment
      find_content_berry_comment_path(berry)
    when :item
      item_path(berry.item)
    when :restaurant
      restaurant_path(berry.restaurant)
    end
  end

  def find_content_berry_comment_path(berry)
    comment = berry.comment
    type = comment.type

    case type
    when :restaurant
      comments_restaurant_path(comment.restaurant)
    when :item
      comments_item_path(comment.item)
    when :reply_comment
      find_comment_path(comment.reply_comment.comment)
    end
  end
end
