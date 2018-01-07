# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# ItemTypes
ItemType.names.each do |name|
  ItemType.create(name: name)
end

ReportReason.names.each do |name|
  ReportReason.create(name: name)
end

# Diets
# Diet.exclusion_keywords
vegan_exclusion_keywords = ['milk',
                            'cheese',
                            'turkey',
                            'ham',
                            'salami',
                            'yogurt',
                            'bacon',
                            'egg',
                            'cream',
                            'yolks',
                            'buttery',
                            'buttermilk',
                            'animal',
                            'dairy',
                            'chicken',
                            'sour cream',
                            'beef',
                            'fish',
                            'pork',
                            'honey',
                            'rib eye steak']
state_names = [
  "Alabama ",
  "Alaska ",
  "Arizona ",
  "Arkansas ",
  "California ",
  "Colorado ",
  "Connecticut ",
  "Delaware ",
  "Florida ",
  "Georgia ",
  "Hawaii ",
  "Idaho ",
  "Illinois Indiana ",
  "Iowa ",
  "Kansas ",
  "Kentucky ",
  "Louisiana ",
  "Maine ",
  "Maryland ",
  "Massachusetts ",
  "Michigan ",
  "Minnesota ",
  "Mississippi ",
  "Missouri ",
  "Montana Nebraska ",
  "Nevada ",
  "New Hampshire ",
  "New Jersey ",
  "New Mexico ",
  "New York ",
  "North Carolina ",
  "North Dakota ",
  "Ohio ",
  "Oklahoma ",
  "Oregon ",
  "Pennsylvania Rhode Island ",
  "South Carolina ",
  "South Dakota ",
  "Tennessee ",
  "Texas ",
  "Utah ",
  "Vermont ",
  "Virginia ",
  "Washington ",
  "West Virginia ",
  "Wisconsin ",
  "Wyoming" ]

Diet.names.each do |name|
  diet = Diet.find_by(name: name) || Diet.new(name: name)
  diet.exclusion_keywords = vegan_exclusion_keywords if name == Diet::VEGAN
  diet.save
end

state_names.each { |name| State.find_or_create_by(name: name) }
