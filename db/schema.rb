# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131106102124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "fullname"
    t.string   "address"
    t.integer  "post_code"
    t.string   "phone"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "area_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "administrators", force: true do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "role",                   default: "admin", null: false
  end

  add_index "administrators", ["email"], name: "index_administrators_on_email", unique: true, using: :btree
  add_index "administrators", ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true, using: :btree

  create_table "areas", force: true do |t|
    t.string  "name"
    t.integer "post_code"
    t.integer "parent_post_code"
    t.boolean "available",        default: false, null: false
  end

  add_index "areas", ["post_code"], name: "index_areas_on_post_code", unique: true, using: :btree

  create_table "assets", force: true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
  end

  add_index "assets", ["viewable_id"], name: "index_assets_on_viewable_id", using: :btree
  add_index "assets", ["viewable_type"], name: "index_assets_on_viewable_type", using: :btree

  create_table "banners", force: true do |t|
    t.string   "name"
    t.string   "content"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string  "name"
    t.integer "post_code"
    t.integer "parent_post_code"
    t.boolean "available",        default: false, null: false
  end

  add_index "cities", ["post_code"], name: "index_cities_on_post_code", unique: true, using: :btree

  create_table "collection_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "collection_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "collection_anc_desc_udx", unique: true, using: :btree
  add_index "collection_hierarchies", ["descendant_id"], name: "collection_desc_idx", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name_zh",                          null: false
    t.string   "description"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "name_en",                          null: false
    t.string   "slug"
    t.boolean  "available",        default: false
    t.string   "display_name"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.boolean  "primary_category", default: false, null: false
    t.string   "meta_title"
    t.integer  "priority",         default: 5
    t.integer  "parent_id"
  end

  add_index "collections", ["slug"], name: "index_collections_on_slug", unique: true, using: :btree

  create_table "collections_products", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "collection_id"
  end

  add_index "collections_products", ["product_id", "collection_id"], name: "index_collections_products_on_product_id_and_collection_id", unique: true, using: :btree

  create_table "coupon_codes", force: true do |t|
    t.string   "code",                        null: false
    t.integer  "available_count", default: 1
    t.integer  "used_count",      default: 0
    t.integer  "coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupon_codes", ["code"], name: "index_coupon_codes_on_code", unique: true, using: :btree
  add_index "coupon_codes", ["coupon_id"], name: "index_coupon_codes_on_coupon_id", using: :btree

  create_table "coupons", force: true do |t|
    t.string   "adjustment",                      null: false
    t.boolean  "expired",         default: false, null: false
    t.date     "expires_at",                      null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "note"
    t.integer  "price_condition"
  end

  create_table "date_rules", force: true do |t|
    t.integer  "product_id"
    t.date     "start_date"
    t.text     "included_dates"
    t.text     "excluded_dates"
    t.string   "excluded_weekdays"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.string   "type"
    t.string   "period_length"
  end

  add_index "date_rules", ["product_id"], name: "index_date_rules_on_product_id", using: :btree

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "monthly_solds", force: true do |t|
    t.integer  "sold_year"
    t.integer  "sold_month"
    t.integer  "sold_total", default: 0
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monthly_solds", ["product_id", "sold_year", "sold_month"], name: "index_monthly_solds_on_product_id_and_sold_year_and_sold_month", unique: true, using: :btree
  add_index "monthly_solds", ["product_id"], name: "index_monthly_solds_on_product_id", using: :btree

  create_table "oauth_services", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

  add_index "oauth_services", ["provider", "uid"], name: "index_oauth_services_on_provider_and_uid", using: :btree

  create_table "orders", force: true do |t|
    t.string   "identifier"
    t.decimal  "item_total",           precision: 8, scale: 2, default: 0.0,      null: false
    t.decimal  "total",                precision: 8, scale: 2, default: 0.0,      null: false
    t.decimal  "payment_total",        precision: 8, scale: 2, default: 0.0
    t.string   "state",                                        default: "ready"
    t.text     "special_instructions"
    t.integer  "address_id"
    t.integer  "user_id"
    t.datetime "completed_at"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.text     "gift_card_text"
    t.date     "expected_date",                                                   null: false
    t.string   "sender_email"
    t.string   "sender_phone"
    t.string   "sender_name"
    t.date     "delivery_date"
    t.string   "source",                                       default: "",       null: false
    t.string   "adjustment"
    t.integer  "ship_method_id"
    t.boolean  "printed",                                      default: false
    t.string   "kind",                                         default: "normal", null: false
    t.integer  "coupon_code_id"
    t.string   "merchant_order_no"
  end

  add_index "orders", ["identifier"], name: "index_orders_on_identifier", unique: true, using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title_zh"
    t.string   "permalink"
    t.text     "content_zh"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "title_en"
    t.text     "content_en"
    t.boolean  "in_footer",        default: true
    t.string   "meta_title"
  end

  add_index "pages", ["permalink"], name: "index_pages_on_permalink", using: :btree

  create_table "period_region_policies", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "not_open"
  end

  create_table "products", force: true do |t|
    t.string   "name_zh",                                              default: "",    null: false
    t.string   "name_en",                                              default: "",    null: false
    t.text     "description"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "count_on_hand",                                        default: 0,     null: false
    t.decimal  "price",                        precision: 8, scale: 2
    t.decimal  "height",                       precision: 8, scale: 2
    t.decimal  "width",                        precision: 8, scale: 2
    t.decimal  "depth",                        precision: 8, scale: 2
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.decimal  "original_price"
    t.text     "inspiration"
    t.string   "slug"
    t.boolean  "published",                                            default: false
    t.integer  "priority",                                             default: 5
    t.string   "meta_title"
    t.integer  "sold_total",                                           default: 0
    t.integer  "default_region_rule_id"
    t.integer  "default_date_rule_id"
    t.string   "rectangle_image_file_name"
    t.string   "rectangle_image_content_type"
    t.integer  "rectangle_image_file_size"
    t.datetime "rectangle_image_updated_at"
    t.string   "sku_id"
  end

  add_index "products", ["default_date_rule_id"], name: "index_products_on_default_date_rule_id", using: :btree
  add_index "products", ["default_region_rule_id"], name: "index_products_on_default_region_rule_id", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", unique: true, using: :btree

  create_table "provinces", force: true do |t|
    t.string  "name"
    t.integer "post_code"
    t.boolean "available", default: false, null: false
  end

  add_index "provinces", ["post_code"], name: "index_provinces_on_post_code", unique: true, using: :btree

  create_table "recommendation_relations", force: true do |t|
    t.integer  "product_id"
    t.integer  "recommendation_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "recommendation_relations", ["product_id"], name: "index_recommendation_relations_on_product_id", using: :btree
  add_index "recommendation_relations", ["recommendation_id"], name: "index_recommendation_relations_on_recommendation_id", using: :btree

  create_table "region_rules", force: true do |t|
    t.integer  "region_rulable_id"
    t.text     "province_ids"
    t.text     "city_ids"
    t.text     "area_ids"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "name"
    t.string   "type"
    t.string   "region_rulable_type"
  end

  add_index "region_rules", ["region_rulable_id"], name: "index_region_rules_on_region_rulable_id", using: :btree

  create_table "reminders", force: true do |t|
    t.string   "email",      null: false
    t.datetime "send_date",  null: false
    t.text     "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "ship_methods", force: true do |t|
    t.string "name"
    t.string "service_phone"
    t.string "method"
    t.string "website"
    t.string "kuaidi_query_code"
    t.string "kuaidi_api_code"
  end

  create_table "shipments", force: true do |t|
    t.string   "identifier"
    t.string   "tracking_num"
    t.string   "state"
    t.text     "note"
    t.integer  "address_id"
    t.integer  "ship_method_id"
    t.integer  "order_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "kuaidi100_result"
    t.string   "kuaidi100_status"
    t.datetime "kuaidi100_updated_at"
  end

  add_index "shipments", ["identifier"], name: "index_shipments_on_identifier", using: :btree
  add_index "shipments", ["order_id"], name: "index_shipments_on_order_id", using: :btree
  add_index "shipments", ["ship_method_id"], name: "index_shipments_on_ship_method_id", using: :btree
  add_index "shipments", ["tracking_num"], name: "index_shipments_on_tracking_num", using: :btree

  create_table "stories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "author_avatar_file_name"
    t.string   "author_avatar_content_type"
    t.integer  "author_avatar_file_size"
    t.datetime "author_avatar_updated_at"
  end

  create_table "surveys", force: true do |t|
    t.integer  "user_id"
    t.string   "gender"
    t.string   "receiver_gender"
    t.string   "gift_purpose"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "tracking_cookies", force: true do |t|
    t.integer  "user_id"
    t.string   "ga_client_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "tracking_cookies", ["user_id"], name: "index_tracking_cookies_on_user_id", using: :btree

  create_table "transactions", force: true do |t|
    t.string   "identifier"
    t.string   "merchant_name"
    t.string   "merchant_trade_no"
    t.string   "paymethod"
    t.string   "subject"
    t.text     "body"
    t.string   "state",                                     default: "generated"
    t.integer  "order_id"
    t.decimal  "amount",            precision: 8, scale: 2
    t.datetime "processed_at"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
  end

  add_index "transactions", ["identifier"], name: "index_transactions_on_identifier", unique: true, using: :btree
  add_index "transactions", ["order_id"], name: "index_transactions_on_order_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "anonymous_token"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "role",                   default: "customer", null: false
    t.string   "phone"
    t.string   "name"
  end

  add_index "users", ["anonymous_token"], name: "index_users_on_anonymous_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
