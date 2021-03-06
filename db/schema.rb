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

ActiveRecord::Schema.define(:version => 20110901193201) do

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

  create_table "admin_meta_datum", :force => true do |t|
    t.string   "relative_path"
    t.text     "title"
    t.text     "description"
    t.text     "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.integer  "user_id"
    t.string   "context"
    t.string   "title"
    t.string   "title_for_url"
    t.string   "teaser"
    t.text     "content"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bullet_points", :force => true do |t|
    t.string   "context"
    t.integer  "context_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["locked_by"], :name => "delayed_jobs_locked_by"
  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "guides", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "title_for_url"
    t.text     "content"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser"
  end

  create_table "phone_numbers", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "number",     :null => false
    t.string   "label"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "qas", :force => true do |t|
    t.integer  "context_id"
    t.string   "context"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reasons_to_sell", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.string   "title_for_url"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser"
  end

  create_table "seller_listings", :force => true do |t|
    t.integer  "user_id",                                                 :null => false
    t.integer  "address_id",                                              :null => false
    t.integer  "phone_number_id",                                         :null => false
    t.decimal  "estimated_value",          :precision => 12, :scale => 2
    t.decimal  "asking_price",             :precision => 12, :scale => 2
    t.decimal  "loan_amount",              :precision => 12, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "selling_reason"
    t.integer  "time_frame"
    t.string   "salesforce_lead_id"
    t.string   "salesforce_lead_owner_id"
  end

  create_table "social_profiles", :force => true do |t|
    t.string   "context"
    t.string   "context_id"
    t.string   "website"
    t.string   "username"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlights", :force => true do |t|
    t.string   "title"
    t.string   "title_for_url"
    t.text     "teaser"
    t.string   "about_title"
    t.string   "interview_title"
    t.string   "interview_subtitle"
    t.string   "social_profile_title"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
  end

  create_table "uploaded_photos", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
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
    t.string   "first_name",                                             :null => false
    t.string   "last_name"
    t.boolean  "admin",                               :default => false
    t.boolean  "copy_editor",                         :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
