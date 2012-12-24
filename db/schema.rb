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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121224075413) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.string   "fullname"
    t.string   "address"
    t.string   "post_code"
    t.string   "phone"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "area_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "order_id"
  end

  create_table "administrators", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "administrators", ["email"], :name => "index_administrators_on_email", :unique => true
  add_index "administrators", ["reset_password_token"], :name => "index_administrators_on_reset_password_token", :unique => true

  create_table "areas", :force => true do |t|
    t.string  "name"
    t.integer "post_code"
    t.integer "parent_post_code"
  end

  add_index "areas", ["post_code"], :name => "index_areas_on_post_code", :unique => true

  create_table "assets", :force => true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "assets", ["viewable_id"], :name => "index_assets_on_viewable_id"
  add_index "assets", ["viewable_type"], :name => "index_assets_on_viewable_type"

  create_table "cities", :force => true do |t|
    t.string  "name"
    t.integer "post_code"
    t.integer "parent_post_code"
  end

  add_index "cities", ["post_code"], :name => "index_cities_on_post_code", :unique => true

  create_table "collections", :force => true do |t|
    t.string   "name_cn",     :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name_en",     :null => false
  end

  create_table "line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.string   "number"
    t.decimal  "item_total",           :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "total",                :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "payment_total",        :precision => 8, :scale => 2, :default => 0.0
    t.string   "state"
    t.string   "payment_state"
    t.string   "shipment_state"
    t.text     "special_instructions"
    t.integer  "address_id"
    t.integer  "user_id"
    t.datetime "completed_at"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.text     "gift_card_text"
    t.date     "delivery_date",                                                       :null => false
  end

  add_index "orders", ["number"], :name => "index_orders_on_number"

  create_table "pages", :force => true do |t|
    t.string   "title_zh"
    t.string   "permalink"
    t.text     "content_zh"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "title_en"
    t.text     "content_en"
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"

  create_table "products", :force => true do |t|
    t.string   "name_zh",                                        :default => "",    :null => false
    t.string   "name_en",                                        :default => "",    :null => false
    t.text     "description_zh"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "count_on_hand",                                  :default => 0,     :null => false
    t.decimal  "cost_price",       :precision => 8, :scale => 2
    t.decimal  "price",            :precision => 8, :scale => 2
    t.decimal  "height",           :precision => 8, :scale => 2
    t.decimal  "width",            :precision => 8, :scale => 2
    t.decimal  "depth",            :precision => 8, :scale => 2
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.boolean  "available",                                      :default => true
    t.integer  "collection_id"
    t.decimal  "original_price"
    t.text     "inspiration_zh"
    t.string   "name_char"
    t.string   "slug"
    t.text     "inspiration_en"
    t.text     "description_en"
    t.boolean  "published_zh",                                   :default => false
    t.boolean  "published_en",                                   :default => false
  end

  add_index "products", ["name_en"], :name => "index_products_on_name_en"
  add_index "products", ["slug"], :name => "index_products_on_slug", :unique => true

  create_table "provinces", :force => true do |t|
    t.string  "name"
    t.integer "post_code"
  end

  add_index "provinces", ["post_code"], :name => "index_provinces_on_post_code", :unique => true

  create_table "transactions", :force => true do |t|
    t.string   "identifier"
    t.string   "merchant_name"
    t.string   "merchant_trade_no"
    t.integer  "order_id"
    t.integer  "amount"
    t.string   "status"
    t.datetime "processed_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "anonymous_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["anonymous_token"], :name => "index_users_on_anonymous_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
