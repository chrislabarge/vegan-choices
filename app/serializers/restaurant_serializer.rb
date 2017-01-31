class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :image, :menu_item_count, :non_menu_item_count

  def serializable_hash(adapter_options = nil, options = {}, adapter_instance = self.class.serialization_adapter_instance)
    hash = super
    hash.each { |key, value| hash.delete(key) if value.nil? }
    hash
  end

  def image
    return unless (path = object.image_path)

    ActionController::Base.helpers.asset_path(path)
  end

  def title
    object.name
  end

  def url
    Rails.application.routes.url_helpers.restaurant_url(object,
                                                        host: ENV['HOST_NAME'])
  end

  def menu_item_count
    object.menu_items.count
  end

  def non_menu_item_count
    object.non_menu_items.count
  end
end
