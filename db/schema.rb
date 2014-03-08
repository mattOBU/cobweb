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

ActiveRecord::Schema.define(version: 20140308184606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "building_groups", force: true do |t|
    t.string   "name"
    t.string   "postcode"
    t.string   "city"
    t.string   "year"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "age_groups"
    t.float    "total_area"
    t.integer  "total_occupancy"
    t.string   "area_accuracy"
    t.string   "occupancy_accuracy"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "buildings", force: true do |t|
    t.string   "street_number"
    t.string   "postcode"
    t.string   "building_type"
    t.integer  "year_of_construction"
    t.integer  "number_of_occupants"
    t.float    "floor_area"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "name"
    t.string   "street_name"
    t.string   "city"
    t.string   "area_accuracy"
    t.string   "occupants_accuract"
    t.string   "category"
    t.integer  "building_group_id"
  end

  create_table "community_groups", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "running_since"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "description"
  end

  create_table "group_energy_profiles", force: true do |t|
    t.string   "age_group"
    t.integer  "building_group_id"
    t.string   "imported_electricity_consumption"
    t.string   "imported_electricity_consumption_unit"
    t.string   "imported_electricity_consumption_accuracy"
    t.string   "generated_electricity_consumption"
    t.string   "generated_electricity_consumption_unit"
    t.string   "generated_electricity_consumption_accuracy"
    t.string   "exported_electricity"
    t.string   "exported_electricity_unit"
    t.string   "exported_electricity_accuracy"
    t.string   "fossil_1_consumption"
    t.string   "fossil_1_consumption_unit"
    t.string   "fossil_1_consumption_accuracy"
    t.string   "fossil_2_consumption"
    t.string   "fossil_2_consumption_unit"
    t.string   "fossil_2_consumption_accuracy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_applications", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
