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

ActiveRecord::Schema.define(version: 20171015225202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "allergens", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "diets", force: :cascade do |t|
    t.string   "name"
    t.text     "exclusion_keywords", default: [],              array: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["restaurant_id"], name: "index_favorites_on_restaurant_id", using: :btree
    t.index ["user_id"], name: "index_favorites_on_user_id", using: :btree
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_allergens", force: :cascade do |t|
    t.integer  "allergen_id"
    t.integer  "item_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["allergen_id"], name: "index_item_allergens_on_allergen_id", using: :btree
    t.index ["item_id"], name: "index_item_allergens_on_item_id", using: :btree
  end

  create_table "item_comments", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_item_comments_on_comment_id", using: :btree
    t.index ["item_id"], name: "index_item_comments_on_item_id", using: :btree
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
    t.string   "allergen_string"
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

  create_table "reply_comments", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "reply_to_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["comment_id"], name: "index_reply_comments_on_comment_id", using: :btree
    t.index ["reply_to_id"], name: "index_reply_comments_on_reply_to_id", using: :btree
  end

  create_table "report_comments", force: :cascade do |t|
    t.string   "custom_reason"
    t.integer  "comment_id"
    t.integer  "report_reason_id"
    t.integer  "report_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["comment_id"], name: "index_report_comments_on_comment_id", using: :btree
    t.index ["report_id"], name: "index_report_comments_on_report_id", using: :btree
    t.index ["report_reason_id"], name: "index_report_comments_on_report_reason_id", using: :btree
  end

  create_table "report_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "report_id"
    t.integer  "report_reason_id"
    t.text     "custom_reason"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["item_id"], name: "index_report_items_on_item_id", using: :btree
    t.index ["report_id"], name: "index_report_items_on_report_id", using: :btree
    t.index ["report_reason_id"], name: "index_report_items_on_report_reason_id", using: :btree
  end

  create_table "report_reasons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_restaurants", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "report_id"
    t.integer  "report_reason_id"
    t.text     "custom_reason"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["report_id"], name: "index_report_restaurants_on_report_id", using: :btree
    t.index ["report_reason_id"], name: "index_report_restaurants_on_report_reason_id", using: :btree
    t.index ["restaurant_id"], name: "index_report_restaurants_on_restaurant_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.text     "info"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "restaurant_comments", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["comment_id"], name: "index_restaurant_comments_on_comment_id", using: :btree
    t.index ["restaurant_id"], name: "index_restaurant_comments_on_restaurant_id", using: :btree
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "view_count", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "restaurants"
  add_foreign_key "favorites", "users"
  add_foreign_key "item_allergens", "allergens"
  add_foreign_key "item_allergens", "items"
  add_foreign_key "item_comments", "comments"
  add_foreign_key "item_comments", "items"
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
  add_foreign_key "reply_comments", "comments", column: "reply_to_id"
  add_foreign_key "report_comments", "comments"
  add_foreign_key "report_comments", "report_reasons"
  add_foreign_key "report_comments", "reports"
  add_foreign_key "report_items", "items"
  add_foreign_key "report_items", "report_reasons"
  add_foreign_key "report_items", "reports"
  add_foreign_key "report_restaurants", "report_reasons"
  add_foreign_key "report_restaurants", "reports"
  add_foreign_key "report_restaurants", "restaurants"
  add_foreign_key "reports", "users"
  add_foreign_key "restaurant_comments", "comments"
  add_foreign_key "restaurant_comments", "restaurants"
end
