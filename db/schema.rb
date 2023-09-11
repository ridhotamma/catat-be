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

ActiveRecord::Schema[7.0].define(version: 2023_09_11_124908) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance_requests", force: :cascade do |t|
    t.bigint "requested_by_id"
    t.bigint "approved_by_id"
    t.string "notes"
    t.date "requested_at"
    t.string "live_location"
    t.string "selfie_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "attendance_status_id", null: false
    t.index ["approved_by_id"], name: "index_attendance_requests_on_approved_by_id"
    t.index ["attendance_status_id"], name: "index_attendance_requests_on_attendance_status_id"
    t.index ["requested_by_id"], name: "index_attendance_requests_on_requested_by_id"
  end

  create_table "attendance_settings", force: :cascade do |t|
    t.boolean "enable_live_location"
    t.boolean "enable_take_selfie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enable_auto_approval_attendance"
    t.bigint "organization_id", null: false
    t.index ["organization_id"], name: "index_attendance_settings_on_organization_id"
  end

  create_table "attendance_statuses", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id", null: false
    t.index ["organization_id"], name: "index_departments_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "profile_picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "department_id", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "attendance_requests", "attendance_statuses"
  add_foreign_key "attendance_requests", "users", column: "approved_by_id"
  add_foreign_key "attendance_requests", "users", column: "requested_by_id"
  add_foreign_key "attendance_settings", "organizations"
  add_foreign_key "departments", "organizations"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "roles"
end
