# frozen_string_literal: true
module CommentsHelper
  def find_comment_path(comment, resource=nil)
    resource ||= find_resource(comment)
    klass = resource.class.name.underscore.to_sym

    if klass == :item || klass == :restaurant
      return send("#{klass}_path", resource, anchor: "comment-#{comment.id}")
    end

    if klass == :comment
      return find_comment_path(resource.reply_comment.reply_to)
    end

    if klass == :reply_comment
      return find_comment_path(resource.reply_to)
    end
  end

  def find_resource(model)
    model.item || model.restaurant || model.reply_comment
  end
end
