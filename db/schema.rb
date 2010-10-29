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

ActiveRecord::Schema.define(:version => 20101023225748) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.string   "address1",                      :null => false
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip",                           :null => false
    t.string   "label"
    t.boolean  "primary",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "number",     :null => false
    t.string   "label"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seller_listings", :force => true do |t|
    t.integer  "user_id",                                             :null => false
    t.integer  "address_id",                                          :null => false
    t.integer  "phone_number_id",                                     :null => false
    t.decimal  "estimated_value",      :precision => 12, :scale => 2
    t.decimal  "asking_price",         :precision => 12, :scale => 2
    t.decimal  "loan_amount",          :precision => 12, :scale => 2
    t.boolean  "currently_listed"
    t.boolean  "payments_are_current"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                                          :null => false
    t.string   "last_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
