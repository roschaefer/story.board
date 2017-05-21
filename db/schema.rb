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

ActiveRecord::Schema.define(version: 20170518133810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actuators", force: :cascade do |t|
    t.string   "name"
    t.integer  "port"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_actuators_on_name", unique: true, using: :btree
  end

  create_table "chains", force: :cascade do |t|
    t.integer  "actuator_id"
    t.integer  "function"
    t.string   "hashtag"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["actuator_id"], name: "index_chains_on_actuator_id", using: :btree
    t.index ["hashtag"], name: "index_chains_on_hashtag", unique: true, using: :btree
  end

  create_table "channels", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_channels_on_name", unique: true, using: :btree
  end

  create_table "channels_text_components", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "text_component_id"
    t.index ["channel_id"], name: "index_channels_text_components_on_channel_id", using: :btree
    t.index ["text_component_id"], name: "index_channels_text_components_on_text_component_id", using: :btree
  end

  create_table "commands", force: :cascade do |t|
    t.integer  "actuator_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "function"
    t.integer  "status",      default: 0, null: false
    t.index ["actuator_id"], name: "index_commands_on_actuator_id", using: :btree
  end

  create_table "conditions", force: :cascade do |t|
    t.integer  "from"
    t.integer  "to"
    t.integer  "trigger_id"
    t.integer  "sensor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sensor_id"], name: "index_conditions_on_sensor_id", using: :btree
    t.index ["trigger_id"], name: "index_conditions_on_trigger_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "happened_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_events_on_name", unique: true, using: :btree
  end

  create_table "events_triggers", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "trigger_id"
    t.index ["event_id"], name: "index_events_triggers_on_event_id", using: :btree
    t.index ["trigger_id"], name: "index_events_triggers_on_trigger_id", using: :btree
  end

  create_table "question_answers", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "text_component_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["text_component_id"], name: "index_question_answers_on_text_component_id", using: :btree
  end

  create_table "records", force: :cascade do |t|
    t.string   "heading"
    t.string   "introduction"
    t.string   "main_part"
    t.string   "closing"
    t.integer  "report_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "intention",    default: 0
    t.index ["report_id"], name: "index_records_on_report_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.date     "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "video"
    t.integer  "duration"
  end

  create_table "sensor_readings", force: :cascade do |t|
    t.float    "calibrated_value"
    t.float    "uncalibrated_value"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "sensor_id"
    t.integer  "intention",          default: 0
    t.index ["sensor_id"], name: "index_sensor_readings_on_sensor_id", using: :btree
  end

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
    t.boolean  "calibrating"
    t.float    "max_value"
    t.float    "min_value"
    t.datetime "calibrated_at"
    t.index ["address"], name: "index_sensors_on_address", unique: true, using: :btree
    t.index ["name"], name: "index_sensors_on_name", unique: true, using: :btree
    t.index ["report_id"], name: "index_sensors_on_report_id", using: :btree
    t.index ["sensor_type_id"], name: "index_sensors_on_sensor_type_id", using: :btree
  end

  create_table "text_components", force: :cascade do |t|
    t.string  "heading"
    t.text    "introduction"
    t.text    "main_part"
    t.text    "closing"
    t.integer "from_day"
    t.integer "to_day"
    t.integer "report_id"
    t.integer "topic_id"
    t.integer "assignee_id"
    t.index ["assignee_id"], name: "index_text_components_on_assignee_id", using: :btree
    t.index ["report_id"], name: "index_text_components_on_report_id", using: :btree
  end

  create_table "text_components_triggers", force: :cascade do |t|
    t.integer "text_component_id"
    t.integer "trigger_id"
    t.index ["text_component_id"], name: "index_text_components_triggers_on_text_component_id", using: :btree
    t.index ["trigger_id"], name: "index_text_components_triggers_on_trigger_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "triggers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "report_id"
    t.integer  "priority"
    t.integer  "timeliness_constraint"
    t.integer  "from_hour"
    t.integer  "to_hour"
    t.index ["report_id"], name: "index_triggers_on_report_id", using: :btree
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "user"
    t.text     "message"
    t.datetime "tweeted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "chain_id"
    t.integer  "command_id"
    t.string   "main_hashtag"
    t.index ["chain_id"], name: "index_tweets_on_chain_id", using: :btree
    t.index ["command_id"], name: "index_tweets_on_command_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "variables", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_variables_on_key", using: :btree
    t.index ["report_id"], name: "index_variables_on_report_id", using: :btree
  end

  add_foreign_key "chains", "actuators"
  add_foreign_key "commands", "actuators"
  add_foreign_key "conditions", "sensors"
  add_foreign_key "conditions", "triggers"
  add_foreign_key "question_answers", "text_components"
  add_foreign_key "text_components", "reports"
  add_foreign_key "text_components", "users", column: "assignee_id"
  add_foreign_key "tweets", "chains"
  add_foreign_key "tweets", "commands"
  add_foreign_key "variables", "reports"
end
