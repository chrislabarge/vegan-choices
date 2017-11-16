# frozen_string_literal: true
module CommentsHelper
  def find_comment_path(comment)
    return comments_item_path(comment.item) if comment.item
    return comments_restaurant_path(comment.restaurant) if comment.restaurant
    return find_comment_path(comment.reply_comment.reply_to) if comment.reply_comment
  end
end
