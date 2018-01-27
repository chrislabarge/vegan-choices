class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :image, :item_count

  def serializable_hash(adapter_options = nil, options = {}, adapter_instance = self.class.serialization_adapter_instance)
    hash = super
    hash.each { |key, value| hash.delete(key) if value.nil? }
    hash
  end

  def image
    return object.thumbnail if object.photo_url.present?
    return '' unless (path = object.image_path)
    return ('/images/' + path) if path == 'no-img.jpeg'
    ActionController::Base.helpers.asset_path(path)
  end

  def title
    object.name
  end

  def url
    Rails.application
         .routes
         .url_helpers
         .restaurant_url(object, host: ENV['HOST_NAME'])
  end

  def item_count
    diet = ENV['DIET']
    items = object.items.send(diet) if diet

    items.count
  end
end
