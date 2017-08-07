namespace :export do
  task restaurants: :environment do
    records = Restaurant.all.to_json(except: [:id, :created_at, :updated_at])

    File.open("restaurants_export.json", 'w') { |f| f.write(records) }
  end

  task :items, [:diet] => [:environment] do |t, args|
    diet = args[:diet]
    items = Item.send(diet)
    records = items.to_json(except: [:id,
                                        :created_at,
                                        :updated_at,
                                        :restaurant_id, :item_type_id],
                               methods: [:restaurant_name, :type_name])

    File.open("item_export.json", 'w') { |f| f.write(records) }
  end
end

