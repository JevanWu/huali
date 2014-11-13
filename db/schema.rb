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

ActiveRecord::Schema.define(version: 20141113084935) do

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

  create_table "appointments", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "customer_phone"
    t.string   "customer_email"
    t.datetime "notify_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appointments", ["product_id"], name: "index_appointments_on_product_id", using: :btree
  add_index "appointments", ["user_id"], name: "index_appointments_on_user_id", using: :btree

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

  create_table "blog_categories", force: true do |t|
    t.string   "name"
    t.string   "name_en"
    t.text     "description"
    t.integer  "position"
    t.string   "slug"
    t.string   "keywords"
    t.integer  "parent_id"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_categories", ["slug"], name: "index_blog_categories_on_slug", unique: true, using: :btree

  create_table "blog_categories_posts", id: false, force: true do |t|
    t.integer "blog_post_id"
    t.integer "blog_category_id"
  end

  create_table "blog_category_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "blog_category_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "blog_category_anc_desc_udx", unique: true, using: :btree
  add_index "blog_category_hierarchies", ["descendant_id"], name: "blog_category_desc_idx", using: :btree

  create_table "blog_posts", force: true do |t|
    t.string   "title"
    t.string   "title_en"
    t.string   "author"
    t.text     "content"
    t.text     "excerpt"
    t.string   "keywords"
    t.string   "slug"
    t.boolean  "published"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
  end

  add_index "blog_posts", ["published"], name: "index_blog_posts_on_published", using: :btree
  add_index "blog_posts", ["slug"], name: "index_blog_posts_on_slug", unique: true, using: :btree

  create_table "cities", force: true do |t|
    t.string  "name"
    t.integer "post_code"
    t.integer "parent_post_code"
    t.boolean "available",        default: false, null: false
  end

  add_index "cities", ["post_code"], name: "index_cities_on_post_code", unique: true, using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "collection_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "collection_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "collection_anc_desc_udx", unique: true, using: :btree
  add_index "collection_hierarchies", ["descendant_id"], name: "collection_desc_idx", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name_zh",                               null: false
    t.string   "description"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "name_en",                               null: false
    t.string   "slug"
    t.boolean  "available",             default: false
    t.string   "display_name"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.boolean  "primary_category",      default: false, null: false
    t.string   "meta_title"
    t.integer  "priority",              default: 5
    t.integer  "parent_id"
    t.boolean  "display_on_breadcrumb", default: false
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
    t.integer  "user_id"
  end

  add_index "coupon_codes", ["code"], name: "index_coupon_codes_on_code", unique: true, using: :btree
  add_index "coupon_codes", ["coupon_id"], name: "index_coupon_codes_on_coupon_id", using: :btree
  add_index "coupon_codes", ["user_id"], name: "index_coupon_codes_on_user_id", using: :btree

  create_table "coupons", force: true do |t|
    t.string   "adjustment",                      null: false
    t.boolean  "expired",         default: false, null: false
    t.date     "expires_at",                      null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "note"
    t.integer  "price_condition"
  end

  create_table "coupons_products", id: false, force: true do |t|
    t.integer "coupon_id"
    t.integer "product_id"
  end

  add_index "coupons_products", ["coupon_id", "product_id"], name: "index_coupons_products_on_coupon_id_and_product_id", unique: true, using: :btree

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

  create_table "didi_passengers", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.integer  "coupon_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "didi_passengers", ["coupon_code_id"], name: "index_didi_passengers_on_coupon_code_id", using: :btree

  create_table "discount_events", force: true do |t|
    t.integer  "product_id"
    t.date     "discount_date"
    t.decimal  "original_price", precision: 8, scale: 2
    t.decimal  "price",          precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "discount_events", ["discount_date"], name: "index_discount_events_on_discount_date", unique: true, using: :btree
  add_index "discount_events", ["product_id", "discount_date"], name: "index_discount_events_on_product_id_and_discount_date", using: :btree
  add_index "discount_events", ["product_id"], name: "index_discount_events_on_product_id", using: :btree

  create_table "greeting_cards", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "sender_email"
    t.string   "recipient_email"
    t.text     "sentiments"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sender_nickname",    default: "", null: false
    t.string   "recipient_nickname", default: "", null: false
  end

  add_index "greeting_cards", ["product_id"], name: "index_greeting_cards_on_product_id", using: :btree
  add_index "greeting_cards", ["user_id"], name: "index_greeting_cards_on_user_id", using: :btree

  create_table "instant_deliveries", force: true do |t|
    t.integer  "order_id"
    t.decimal  "fee",                  precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "delivered_in_minutes",                                       null: false
    t.datetime "shipped_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "limited_promotions", force: true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.string   "adjustment"
    t.integer  "product_id"
    t.integer  "available_count"
    t.integer  "used_count",      default: 0
    t.boolean  "expired"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "limited_promotions", ["product_id"], name: "index_limited_promotions_on_product_id", using: :btree

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal  "price"
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

  create_table "oauth_providers", force: true do |t|
    t.string   "identifier"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_providers", ["identifier", "provider"], name: "index_oauth_providers_on_identifier_and_provider", unique: true, using: :btree
  add_index "oauth_providers", ["user_id"], name: "index_oauth_providers_on_user_id", using: :btree

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
    t.date     "expected_date"
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
    t.string   "last_order"
    t.boolean  "prechecked"
    t.text     "memo"
    t.text     "subject_text",                                 default: ""
    t.string   "validation_code"
  end

  add_index "orders", ["identifier"], name: "index_orders_on_identifier", unique: true, using: :btree
  add_index "orders", ["merchant_order_no", "kind"], name: "index_orders_on_merchant_order_no_and_kind", using: :btree
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

  create_table "point_transactions", force: true do |t|
    t.decimal  "point",            precision: 8, scale: 2, default: 0.0
    t.string   "transaction_type"
    t.string   "description"
    t.date     "expires_on"
    t.integer  "user_id"
    t.integer  "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "point_transactions", ["transaction_id"], name: "index_point_transactions_on_transaction_id", using: :btree
  add_index "point_transactions", ["user_id"], name: "index_point_transactions_on_user_id", using: :btree

  create_table "postcards", force: true do |t|
    t.string   "identifier"
    t.text     "content"
    t.string   "question"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.string   "slug"
  end

  add_index "postcards", ["identifier"], name: "index_postcards_on_identifier", using: :btree
  add_index "postcards", ["order_id"], name: "index_postcards_on_order_id", using: :btree

  create_table "print_groups", force: true do |t|
    t.string   "name"
    t.integer  "ship_method_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "print_groups", ["name"], name: "index_print_groups_on_name", unique: true, using: :btree
  add_index "print_groups", ["ship_method_id"], name: "index_print_groups_on_ship_method_id", using: :btree

  create_table "print_orders", force: true do |t|
    t.integer  "order_id"
    t.integer  "print_group_id"
    t.boolean  "order_printed",    default: false
    t.boolean  "card_printed",     default: false
    t.boolean  "shipment_printed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "print_orders", ["order_id"], name: "index_print_orders_on_order_id", unique: true, using: :btree
  add_index "print_orders", ["print_group_id"], name: "index_print_orders_on_print_group_id", using: :btree

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
    t.string   "product_type"
    t.boolean  "discountable",                                         default: true
    t.string   "promo_tag"
    t.string   "flower_type"
    t.text     "material"
    t.text     "maintenance"
    t.text     "delivery"
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

  create_table "refunds", force: true do |t|
    t.integer  "order_id"
    t.integer  "transaction_id"
    t.string   "state"
    t.string   "merchant_refund_id"
    t.decimal  "amount"
    t.string   "reason"
    t.string   "ship_method"
    t.string   "tracking_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "refunds", ["order_id", "merchant_refund_id"], name: "index_refunds_on_order_id_and_merchant_refund_id", unique: true, using: :btree
  add_index "refunds", ["order_id"], name: "index_refunds_on_order_id", using: :btree
  add_index "refunds", ["transaction_id"], name: "index_refunds_on_transaction_id", using: :btree

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

  create_table "reply_greeting_cards", force: true do |t|
    t.integer  "greeting_card_id"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reply_greeting_cards", ["greeting_card_id"], name: "index_reply_greeting_cards_on_greeting_card_id", using: :btree

  create_table "sales_charts", force: true do |t|
    t.integer  "product_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales_charts", ["product_id"], name: "index_sales_charts_on_product_id", using: :btree

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

  create_table "slide_panels", force: true do |t|
    t.string   "name"
    t.string   "href"
    t.integer  "priority"
    t.boolean  "visible",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

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
    t.string   "origin_link"
    t.integer  "priority",                   default: 0
  end

  create_table "surveys", force: true do |t|
    t.integer  "user_id"
    t.string   "gender"
    t.string   "receiver_gender"
    t.string   "gift_purpose"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "receiver_age"
    t.string   "relationship"
  end

  create_table "sync_orders", force: true do |t|
    t.integer  "administrator_id"
    t.integer  "order_id"
    t.string   "kind"
    t.string   "merchant_order_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sync_orders", ["administrator_id"], name: "index_sync_orders_on_administrator_id", using: :btree
  add_index "sync_orders", ["order_id"], name: "index_sync_orders_on_order_id", using: :btree

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
    t.string   "client_ip"
    t.boolean  "use_huali_point",                           default: false
  end

  add_index "transactions", ["identifier"], name: "index_transactions_on_identifier", unique: true, using: :btree
  add_index "transactions", ["order_id"], name: "index_transactions_on_order_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "encrypted_password",                               default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                    default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "anonymous_token"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.string   "role",                                             default: "customer", null: false
    t.string   "phone"
    t.string   "name"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invited_and_paid_counter",                         default: 0
    t.boolean  "invitation_rewarded",                              default: false
    t.decimal  "huali_point",              precision: 8, scale: 2, default: 0.0
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["anonymous_token"], name: "index_users_on_anonymous_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
