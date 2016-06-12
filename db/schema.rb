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

ActiveRecord::Schema.define(version: 20160612222831) do

  create_table "conditions", force: :cascade do |t|
    t.integer  "from"
    t.integer  "to"
    t.integer  "text_component_id"
    t.integer  "sensor_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "conditions", ["sensor_id"], name: "index_conditions_on_sensor_id"
  add_index "conditions", ["text_component_id"], name: "index_conditions_on_text_component_id"

  create_table "reports", force: :cascade do |t|
    t.date     "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "sensor_readings", force: :cascade do |t|
    t.float    "calibrated_value"
    t.float    "uncalibrated_value"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "sensor_id"
    t.integer  "source",             default: 0
  end

  add_index "sensor_readings", ["sensor_id"], name: "index_sensor_readings_on_sensor_id"

  create_table "sensor_types", force: :cascade do |t|
    t.string   "property"
    t.string   "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensors", force: :cascade do |t|
    t.string   "name"
    t.integer  "address"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "sensor_type_id"
    t.integer  "report_id"
  end

  add_index "sensors", ["address"], name: "index_sensors_on_address", unique: true
  add_index "sensors", ["name"], name: "index_sensors_on_name", unique: true
  add_index "sensors", ["report_id"], name: "index_sensors_on_report_id"
  add_index "sensors", ["sensor_type_id"], name: "index_sensors_on_sensor_type_id"

  create_table "text_components", force: :cascade do |t|
    t.string   "heading"
    t.text     "introduction"
    t.text     "main_part"
    t.text     "closing"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "report_id"
    t.integer  "priority"
  end

  add_index "text_components", ["report_id"], name: "index_text_components_on_report_id"

end
