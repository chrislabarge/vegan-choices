# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170615001203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "diets", force: :cascade do |t|
    t.string   "name"
    t.text     "exclusion_keywords", default: [],              array: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_diets", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "diet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "certified"
    t.index ["diet_id"], name: "index_item_diets_on_diet_id", using: :btree
    t.index ["item_id"], name: "index_item_diets_on_item_id", using: :btree
  end

  create_table "item_ingredients", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "ingredient_id"
    t.integer  "parent_id"
    t.string   "description"
    t.string   "context"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ingredient_id"], name: "index_item_ingredients_on_ingredient_id", using: :btree
    t.index ["item_id"], name: "index_item_ingredients_on_item_id", using: :btree
  end

  create_table "item_listings", force: :cascade do |t|
    t.string   "path"
    t.string   "filename"
    t.integer  "restaurant_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "url"
    t.hstore   "data_extract_options", default: {}, null: false
    t.index ["restaurant_id"], name: "index_item_listings_on_restaurant_id", using: :btree
  end

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.integer  "item_type_id"
    t.string   "ingredient_string"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "allergens"
    t.index ["item_type_id"], name: "index_items_on_item_type_id", using: :btree
    t.index ["restaurant_id"], name: "index_items_on_restaurant_id", using: :btree
  end

  create_table "recipe_items", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_recipe_items_on_item_id", using: :btree
    t.index ["recipe_id"], name: "index_recipe_items_on_recipe_id", using: :btree
  end

  create_table "recipes", force: :cascade do |t|
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_recipes_on_item_id", using: :btree
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "view_count", default: 0
  end

  add_foreign_key "item_diets", "diets"
  add_foreign_key "item_diets", "items"
  add_foreign_key "item_ingredients", "ingredients"
  add_foreign_key "item_ingredients", "items"
  add_foreign_key "item_listings", "restaurants"
  add_foreign_key "items", "item_types"
  add_foreign_key "items", "restaurants"
  add_foreign_key "recipe_items", "items"
  add_foreign_key "recipe_items", "recipes"
  add_foreign_key "recipes", "items"
end
