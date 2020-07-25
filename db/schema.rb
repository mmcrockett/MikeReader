# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_24_015643) do

  create_table "entries", force: :cascade do |t|
    t.string "subject", null: false
    t.string "link", null: false
    t.text "data", null: false
    t.date "post_date", null: false
    t.integer "feed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "pod", default: false
    t.boolean "read", default: false
    t.index ["feed_id"], name: "index_entries_on_feed_id"
  end

  create_table "feeds", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "display", default: true
  end

  add_foreign_key "entries", "feeds"
end
