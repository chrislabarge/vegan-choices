class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :name, :menu_item_count, :non_menu_item_count

  def menu_item_count
    object.menu_items.count
  end

  def non_menu_item_count
    object.non_menu_items.count
  end
end
