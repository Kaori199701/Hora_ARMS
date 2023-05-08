# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_05_01_041017) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "workers_id", null: false
    t.integer "working_hour_id", null: false
    t.time "start_worktime", null: false
    t.time "finish_worktime", null: false
    t.time "start_breaktime", null: false
    t.time "finish_breaktime", null: false
    t.string "comment", null: false
    t.integer "year_status", default: 0, null: false
    t.integer "month_status", default: 0, null: false
    t.integer "reason_status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "department_code", null: false
    t.string "department_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "directors", force: :cascade do |t|
    t.string "director_code", null: false
    t.string "director_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "location_code", null: false
    t.string "location_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "department_id", null: false
    t.integer "location_id", null: false
    t.integer "director_id", null: false
    t.integer "working_hour_id", null: false
    t.string "employee_number", null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.integer "sex", default: 0, null: false
    t.date "birthday", null: false
    t.date "hire_date", null: false
    t.date "retirement_date", null: false
    t.date "start_career_break", null: false
    t.date "finish_career_break", null: false
    t.integer "employment_status", default: 0, null: false
    t.string "password_digest", limit: 191, null: false
    t.string "remember_token", limit: 191
    t.index ["email"], name: "index_workers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_workers_on_reset_password_token", unique: true
  end

  create_table "working_hours", force: :cascade do |t|
    t.string "working_hour_code", null: false
    t.time "start_working_hour", null: false
    t.time "finish_working_hour", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
