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

ActiveRecord::Schema.define(version: 20151015224945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "activity_type_id"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "activities", ["activity_type_id", "slug"], name: "index_activities_on_activity_type_id_and_slug", unique: true, using: :btree

  create_table "activity_types", force: :cascade do |t|
    t.integer "event_id"
    t.string  "name"
    t.string  "slug"
    t.integer "position", default: 0
  end

  add_index "activity_types", ["event_id", "slug"], name: "index_activity_types_on_event_id_and_slug", unique: true, using: :btree

  create_table "administrators", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "administrators", ["event_id", "user_id"], name: "index_administrators_on_event_id_and_user_id", unique: true, using: :btree
  add_index "administrators", ["user_id"], name: "index_administrators_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "starts_at"
    t.datetime "stops_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.date     "starts_on"
    t.date     "ends_on"
    t.string   "time_zone",  default: "Wellington"
  end

  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree
  add_index "events", ["starts_at", "stops_at"], name: "index_events_on_starts_at_and_stops_at", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "limits", force: :cascade do |t|
    t.integer "package_id"
    t.integer "activity_type_id"
    t.integer "maximum",          default: 0
  end

  add_index "limits", ["package_id", "activity_type_id"], name: "index_limits_on_package_id_and_activity_type_id", unique: true, using: :btree

  create_table "packages", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "name"
    t.string   "slug"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "packages", ["event_id", "id"], name: "index_packages_on_event_id_and_id", unique: true, using: :btree
  add_index "packages", ["event_id", "slug"], name: "index_packages_on_event_id_and_slug", unique: true, using: :btree

  create_table "registrations", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "package_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "registrations", ["package_id", "user_id"], name: "index_registrations_on_package_id_and_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "avatar"
    t.boolean  "users",                  default: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "activities", "activity_types", on_delete: :cascade
  add_foreign_key "activity_types", "events", on_delete: :cascade
  add_foreign_key "administrators", "events", on_delete: :cascade
  add_foreign_key "administrators", "users", on_delete: :cascade
  add_foreign_key "identities", "users", on_delete: :cascade
  add_foreign_key "limits", "activity_types", on_delete: :cascade
  add_foreign_key "limits", "packages", on_delete: :cascade
  add_foreign_key "packages", "events", on_delete: :cascade
  add_foreign_key "registrations", "events", on_delete: :cascade
  add_foreign_key "registrations", "packages", on_delete: :cascade
  add_foreign_key "registrations", "users", on_delete: :cascade
end
