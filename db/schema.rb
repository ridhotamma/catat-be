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

ActiveRecord::Schema[7.0].define(version: 2023_09_12_171737) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attendance_requests", force: :cascade do |t|
    t.bigint "requested_by_id"
    t.bigint "approved_by_id"
    t.string "notes"
    t.datetime "requested_at"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id", null: false
    t.bigint "organization_id"
    t.bigint "department_id"
    t.string "first_name"
    t.string "last_name"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attendance_requests", "attendance_statuses"
  add_foreign_key "attendance_requests", "users", column: "approved_by_id"
  add_foreign_key "attendance_requests", "users", column: "requested_by_id"
  add_foreign_key "attendance_settings", "organizations"
  add_foreign_key "departments", "organizations"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "organizations"
  add_foreign_key "users", "roles"
end
