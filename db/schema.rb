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

ActiveRecord::Schema.define(version: 20160114100741) do

  create_table "dashboards", force: :cascade do |t|
    t.string   "key",             limit: 20,  null: false
    t.string   "name",            limit: 255, null: false
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "dashboards", ["key"], name: "index_dashboards_on_key", unique: true, using: :btree

  create_table "product_line_event_types", force: :cascade do |t|
    t.integer  "product_line_id",  limit: 4, null: false
    t.integer  "event_type_id",    limit: 4, null: false
    t.integer  "order",            limit: 4, null: false
    t.integer  "turn_around_time", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "product_line_event_types", ["product_line_id"], name: "index_product_line_event_types_on_product_line_id", using: :btree

  create_table "product_lines", force: :cascade do |t|
    t.string   "name",            limit: 255, null: false
    t.integer  "dashboard_id",    limit: 4,   null: false
    t.integer  "role_type_id",    limit: 4,   null: false
    t.integer  "subject_type_id", limit: 4,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "product_lines", ["dashboard_id"], name: "index_product_lines_on_dashboard_id", using: :btree

end
