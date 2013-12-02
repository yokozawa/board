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

ActiveRecord::Schema.define(version: 20131118121344) do

  create_table "boards", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delete_flg"
  end

  create_table "tasks", force: true do |t|
    t.integer   "board_id"
    t.date      "target_date"
    t.integer   "sort_order"
    t.text      "body"
    t.binary    "delete_flg",  limit: 1, default: "b'0'"
    t.datetime  "created_at"
    t.timestamp "updated_at",                             null: false
  end

  create_table "user_to_boards", force: true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delete_flg"
  end

end
