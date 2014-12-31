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

ActiveRecord::Schema.define(version: 20141230121148) do

  create_table "about_us", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "access_ids", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_details", force: true do |t|
    t.string   "full_name"
    t.string   "stripe_card_id_token"
    t.string   "stripe_recipient_token"
    t.string   "card_number"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bank_details", ["user_id"], name: "index_bank_details_on_user_id", using: :btree

  create_table "bookings", force: true do |t|
    t.string   "stripe_customer_token"
    t.string   "stripe_charge_id"
    t.string   "stripe_transfer_id"
    t.string   "status"
    t.float    "price"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "poster_id"
    t.string   "email"
    t.date     "dropoff_date"
    t.float    "dropoff_price"
    t.date     "pickup_date"
    t.float    "pickup_price"
    t.float    "cut_off_price"
    t.boolean  "is_cancel",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area"
    t.boolean  "is_confirm",            default: false
    t.float    "commission"
    t.text     "comment"
    t.float    "refund_finder"
  end

  add_index "bookings", ["post_id"], name: "index_bookings_on_post_id", using: :btree
  add_index "bookings", ["poster_id"], name: "index_bookings_on_poster_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.string   "name"
    t.text     "comments"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stars",      default: 0
    t.integer  "rating"
    t.integer  "user_id"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contactus", force: true do |t|
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faq_questions", force: true do |t|
    t.integer  "faq_id"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faq_questions", ["faq_id"], name: "index_faq_questions_on_faq_id", using: :btree

  create_table "faqs", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "messages", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.boolean  "is_read",                 default: false
    t.boolean  "is_deleted_by_sender",    default: false
    t.boolean  "is_deleted_by_recipient", default: false
    t.boolean  "is_trashed_by_recipient", default: false
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "message_id"
    t.integer  "post_id"
  end

  add_index "messages", ["message_id"], name: "index_messages_on_message_id", using: :btree
  add_index "messages", ["post_id"], name: "index_messages_on_post_id", using: :btree
  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "meta_title"
    t.text     "meta_description"
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
    t.boolean  "archive",                        default: false
    t.boolean  "featured",                       default: false
    t.string   "miles"
    t.text     "street_add"
    t.string   "apt"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.float    "area_available",                 default: 0.0
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "ratings", force: true do |t|
    t.decimal  "value",      precision: 10, scale: 0
    t.integer  "vote_count"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "rater_id"
    t.string   "rater_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["item_id", "item_type"], name: "index_ratings_on_item_id_and_item_type", using: :btree
  add_index "ratings", ["rater_id", "rater_type"], name: "index_ratings_on_rater_id_and_rater_type", using: :btree

  create_table "reviews", force: true do |t|
    t.string   "name"
    t.integer  "stars"
    t.string   "comments"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["post_id"], name: "index_reviews_on_post_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                           default: "",    null: false
    t.string   "encrypted_password",              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "admin",                           default: false
    t.boolean  "status",                          default: true
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "last_name"
    t.string   "personal_email"
    t.integer  "mobile_no"
    t.string   "mobile_number"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "notification_for_email"
    t.boolean  "notification_for_personal_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
