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

ActiveRecord::Schema.define(version: 20160910092910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actuators", force: :cascade do |t|
    t.string   "name"
    t.integer  "port"
    t.string   "function"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "actuators", ["name"], name: "index_actuators_on_name", unique: true, using: :btree

  create_table "commands", force: :cascade do |t|
    t.integer  "actuator_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "value"
    t.integer  "status",      default: 0, null: false
  end

  add_index "commands", ["actuator_id"], name: "index_commands_on_actuator_id", using: :btree

  create_table "conditions", force: :cascade do |t|
    t.integer  "from"
    t.integer  "to"
    t.integer  "text_component_id"
    t.integer  "sensor_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "conditions", ["sensor_id"], name: "index_conditions_on_sensor_id", using: :btree
  add_index "conditions", ["text_component_id"], name: "index_conditions_on_text_component_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "happened_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "events", ["name"], name: "index_events_on_name", unique: true, using: :btree

  create_table "events_text_components", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "text_component_id"
  end

  add_index "events_text_components", ["event_id"], name: "index_events_text_components_on_event_id", using: :btree
  add_index "events_text_components", ["text_component_id"], name: "index_events_text_components_on_text_component_id", using: :btree

  create_table "records", force: :cascade do |t|
    t.string   "heading"
    t.string   "introduction"
    t.string   "main_part"
    t.string   "closing"
    t.integer  "report_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "intention",    default: 0
  end

  add_index "records", ["report_id"], name: "index_records_on_report_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.date     "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "video"
  end

  create_table "sensor_readings", force: :cascade do |t|
    t.float    "calibrated_value"
    t.float    "uncalibrated_value"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "sensor_id"
    t.integer  "intention",          default: 0
  end

  add_index "sensor_readings", ["sensor_id"], name: "index_sensor_readings_on_sensor_id", using: :btree

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

  add_index "sensors", ["address"], name: "index_sensors_on_address", unique: true, using: :btree
  add_index "sensors", ["name"], name: "index_sensors_on_name", unique: true, using: :btree
  add_index "sensors", ["report_id"], name: "index_sensors_on_report_id", using: :btree
  add_index "sensors", ["sensor_type_id"], name: "index_sensors_on_sensor_type_id", using: :btree

  create_table "text_components", force: :cascade do |t|
    t.string   "heading"
    t.text     "introduction"
    t.text     "main_part"
    t.text     "closing"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "report_id"
    t.integer  "priority"
    t.integer  "timeliness_constraint"
  end

  add_index "text_components", ["report_id"], name: "index_text_components_on_report_id", using: :btree

  create_table "variables", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "variables", ["key"], name: "index_variables_on_key", unique: true, using: :btree
  add_index "variables", ["report_id"], name: "index_variables_on_report_id", using: :btree

  add_foreign_key "commands", "actuators"
  add_foreign_key "conditions", "sensors"
  add_foreign_key "conditions", "text_components"
  add_foreign_key "variables", "reports"
end
