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

ActiveRecord::Schema.define(version: 20151129171542) do

  create_table "application_detail", force: :cascade do |t|
    t.string   "name"
    t.string   "environment"
    t.string   "rest_method"
    t.text     "uri"
    t.text     "request_hdr"
    t.text     "request_text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "application_detail", ["name"], name: "index_application_detail_on_name"
  add_index "application_detail", ["uri"], name: "index_application_detail_on_uri"

  create_table "application_details", force: :cascade do |t|
    t.string   "name"
    t.string   "environment"
    t.text     "uri"
    t.text     "request_hdr"
    t.text     "request_text"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "rest_method"
  end

  create_table "rules_engines", force: :cascade do |t|
    t.string   "name"
    t.text     "json_attribute"
    t.string   "operator"
    t.string   "value"
    t.string   "color"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "rules_engines", ["json_attribute"], name: "index_rules_engines_on_json_attribute"
  add_index "rules_engines", ["name"], name: "index_rules_engines_on_name"

end
