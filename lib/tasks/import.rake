namespace :import do
  task restaurants: :environment do
    file = $stdin.read
    records = JSON.parse(file)
    imported = records.map { |record |Restaurant.find_or_create_by(record) }

    puts "Succesfully Imported Restaurants!"

    imported
  end

  task items: :environment do
    data = $stdin.read
    importer =  ItemImporter.new(data)

    importer.import
  end
end

# THE IMPORT TASK IS FAILING MISERBALY.on heroku....
#  not concatting for some reason, I think it may be because of the option??
