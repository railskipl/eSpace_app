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

ActiveRecord::Schema.define(version: 20141009104807) do

  create_table "bank_details", force: true do |t|
    t.string   "full_name"
    t.integer  "card_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contactus", force: true do |t|
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.float    "area"
    t.float    "price_sq_ft"
    t.boolean  "pick_up",                        default: false
    t.boolean  "drop_off",                       default: false
    t.float    "price_include_pick_up"
    t.float    "price_include_drop_off"
    t.date     "pick_up_avaibilty_start_date"
    t.date     "pick_up_avaibility_end_date"
    t.date     "drop_off_avaibility_start_date"
    t.date     "drop_off_avaibility_end_date"
    t.boolean  "status",                         default: true
    t.text     "additional_comments"
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "admin",                  default: false
    t.string   "provider"
    t.string   "uid"
    t.boolean  "status"
    t.string   "name"
    t.string   "last_name"
    t.string   "personal_email"
    t.integer  "mobile_no"
    t.string   "mobile_number"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
