module ApplicationHelper
  def image_path(object)
    object.image_path || 'no-img.jpeg'
  end
end
