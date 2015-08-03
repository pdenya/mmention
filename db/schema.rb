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

ActiveRecord::Schema.define(version: 20150802195304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "thread_url"
    t.text     "text"
    t.string   "user"
    t.datetime "posted_at"
    t.string   "subreddit"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "thread_title"
    t.string   "url"
    t.string   "remote_id"
    t.integer  "score"
  end

  create_table "references", force: :cascade do |t|
    t.integer  "video_id"
    t.integer  "comment_id"
    t.string   "link_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "references", ["comment_id"], name: "index_references_on_comment_id", using: :btree
  add_index "references", ["video_id"], name: "index_references_on_video_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.datetime "posted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "references", "comments"
  add_foreign_key "references", "videos"
end
