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

ActiveRecord::Schema.define(version: 20160209124655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backup_histories", force: :cascade do |t|
    t.string   "status"
    t.integer  "backup_id"
    t.integer  "user_id"
    t.string   "item_name"
    t.string   "item_size"
    t.datetime "backup_start_time"
    t.datetime "backup_end_time"
    t.integer  "source_connector_id"
    t.integer  "destination_connector_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "backups", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
    t.date     "next_backup_date"
    t.date     "last_backup_date"
    t.integer  "frequency",        default: 7
    t.integer  "transfer_id"
    t.boolean  "queued",           default: false
  end

  create_table "connectors", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "type"
    t.string   "host"
    t.integer  "port"
    t.string   "name"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "transfers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "source_connector_id"
    t.integer  "destination_connector_id"
    t.string   "item_name"
    t.string   "destination_path"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
