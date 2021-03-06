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

ActiveRecord::Schema.define(version: 2018_11_27_205309) do

  create_table "exhibit_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_id"
    t.integer "mercari_user_id"
    t.integer "user_id"
    t.string "mercari_item_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "mercari_user_id"
    t.string "image1"
    t.string "image2"
    t.string "image3"
    t.string "image4"
    t.string "item_name"
    t.integer "category"
    t.integer "shipping_duration"
    t.integer "item_condition"
    t.integer "price"
    t.integer "shipping_from_area"
    t.integer "shipping_method"
    t.integer "shipping_payer"
    t.text "contents"
    t.boolean "auto_exhibit_flag", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_auto_exhibit_date"
  end

  create_table "mercari_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "image_full_filepath"
    t.string "email", null: false
    t.string "password", null: false
    t.string "name", null: false
    t.text "access_token", null: false
    t.text "global_access_token", null: false
    t.boolean "in_progress", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "exhibit_interval", default: 2
    t.string "refresh_token"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
