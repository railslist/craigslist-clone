# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "permalink",  :limit => 75
    t.integer  "parent_id",                 :default => 0
    t.string   "type",       :limit => 12
    t.integer  "pos",                       :default => 0
    t.string   "pagetitle",  :limit => 100, :default => "railslist.com"
    t.string   "metakey",                   :default => "railslist.com"
    t.string   "metadesc",                  :default => "railslist.com"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "permalink",  :limit => 75
    t.string   "pagetitle",  :limit => 100
    t.string   "metakey"
    t.string   "metadesc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "classifieds", :force => true do |t|
    t.string   "title",              :limit => 75
    t.text     "description"
    t.string   "location",           :limit => 75
    t.string   "adtype",             :limit => 1,  :default => "O"
    t.string   "email",              :limit => 75
    t.string   "phone",              :limit => 75
    t.string   "activation_code",    :limit => 40
    t.integer  "status",             :limit => 1,  :default => 0
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.integer  "city_id"
    t.string   "permalink"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
