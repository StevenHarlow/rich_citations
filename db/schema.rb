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

ActiveRecord::Schema.define(version: 20141027201050) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "paper_info_caches", force: true do |t|
    t.string   "identifier", null: false
    t.text     "info_json"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["identifier"], :name => "index_paper_info_caches_on_identifier"
  end

  create_table "paper_results", force: true do |t|
    t.string   "doi",        null: false
    t.text     "info_json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "result_sets", force: true do |t|
    t.string   "token",        limit: 64, null: false
    t.string   "query",                   null: false
    t.integer  "limit",                   null: false
    t.text     "query_result"
    t.text     "results_json"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "dois"
  end

end
