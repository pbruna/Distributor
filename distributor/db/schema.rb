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

ActiveRecord::Schema.define(:version => 20120515153208) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "jobs", :force => true do |t|
    t.integer  "package_id",                       :null => false
    t.integer  "server_id",                        :null => false
    t.integer  "process_id",                       :null => false
    t.datetime "start_time",                       :null => false
    t.datetime "finish_time"
    t.boolean  "completed",     :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "error_message"
    t.integer  "user_id",                          :null => false
  end

  add_index "jobs", ["package_id"], :name => "index_jobs_on_package_id"
  add_index "jobs", ["server_id"], :name => "index_jobs_on_server_id"
  add_index "jobs", ["user_id"], :name => "index_jobs_on_user_id"

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.string   "file"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "size"
    t.string   "content_type"
    t.integer  "user_id",      :null => false
  end

  create_table "packages_servers", :force => true do |t|
    t.integer  "package_id"
    t.integer  "server_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "packages_servers", ["server_id", "package_id"], :name => "index_packages_servers_on_server_id_and_package_id"

  create_table "servers", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "ip_address",                    :null => false
    t.string   "creator",                       :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "active",     :default => false
  end

  add_index "servers", ["ip_address"], :name => "index_servers_on_ip_address", :unique => true
  add_index "servers", ["name"], :name => "index_servers_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name",             :default => "",    :null => false
    t.string   "last_name",              :default => "",    :null => false
    t.boolean  "admin",                  :default => false, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
