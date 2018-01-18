require 'rails_helper'

describe "rake export:restaurants", type: :task do
  it 'exports the restaurant' do
    restaurant = FactoryBot.create(:restaurant, location: nil)
    export_file_name = 'restaurants_export.json'

    task.execute

    actual = File.exists? export_file_name

    expect(actual).to eq true
    data = File.open(export_file_name).read

    expect(data).to include restaurant.name
    expect(data).not_to include restaurant.id.to_s
    expect(data).not_to include restaurant.created_at.to_s
    expect(data).not_to include restaurant.updated_at.to_s

    data = File.delete(export_file_name)
  end
end

#I am unable to test this out right now because the config doesnt parse the parameters correctly
# describe "rake export:items", type: :task do
#   it 'exports the item' do
#     item = FactoryBot.create(:item)
#     diet = FactoryBot.create(:diet, name: 'vegan')
#     FactoryBot.create(:item_diet, item: item, diet: diet)
#     export_file_name = 'items_export.json'

#     allow(task).to receive(:args) { diet }

#     task.execute

#     actual = File.exists? export_file_name

#     expect(actual).to eq true
#     data = File.open(export_file_name).read

#     byebug
#     expect(data).to include item.name
#     expect(data).to include item.restaurant_name
#     expect(data).to include item.type_name
#     expect(data).not_to include item.id.to_s
#     expect(data).not_to include item.created_at.to_s
#     expect(data).not_to include item.updated_at.to_s
#   end
# end
