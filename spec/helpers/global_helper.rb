module GlobalHelper
  def create_all_item_types
    ItemType.names.each { |n| FactoryBot.create(:item_type, name: n) }
  end

  def destroy_all_item_types
    ItemType.all.each(&:destroy)
  end

  def create_all_diets
    Diet.names.each { |n| FactoryBot.create(:diet, name: n) }
  end

  def destroy_all_diets
    Diet.all.each(&:destroy)
  end
end
