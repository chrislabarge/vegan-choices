# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Restaurants
Restaurant.create(name: "McDonald's", website: 'https://www.mcdonalds.com')

# ItemTypes
ItemType.names.each do |name|
  ItemType.create(name: name)
end

# Diets
# Diet.exclusion_keywords
vegan_exclusion_keywords = ['milk',
                            'egg',
                            'yolks',
                            'buttermilk',
                            'animal',
                            'dairy',
                            'chicken',
                            'sour cream',
                            'beef']

Diet.names.each do |name|
  diet = Diet.find_by(name: name) || Diet.new(name: name)
  diet.exclusion_keywords = vegan_exclusion_keywords if name == Diet::VEGAN
  diet.save
end


