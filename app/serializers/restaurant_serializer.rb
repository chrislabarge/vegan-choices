class RestaurantSerializer < ActiveModel::Serializer
  attributes :id, :text, :menu_item_count, :non_menu_item_count

  def text
    object.name
  end

  def menu_item_count
    object.menu_items.count
  end

  def non_menu_item_count
    object.non_menu_items.count
  end
end
