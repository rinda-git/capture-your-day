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

ActiveRecord::Schema[8.1].define(version: 2026_06_25_050242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "journal_corrections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "journal_id", null: false
    t.text "original_text", null: false
    t.text "rewritten_text", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["journal_id"], name: "index_journal_corrections_on_journal_id"
    t.index ["user_id"], name: "index_journal_corrections_on_user_id"
  end

  create_table "journals", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "mood"
    t.date "posted_date", null: false
    t.string "title"
    t.integer "tone"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_journals_on_user_id"
  end

  create_table "mistakes", force: :cascade do |t|
    t.text "corrected_text"
    t.datetime "created_at", null: false
    t.text "explanation"
    t.bigint "journal_correction_id"
    t.bigint "journal_id", null: false
    t.jsonb "learning_points", default: {}, null: false
    t.integer "mistake_type"
    t.text "original_text", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["journal_correction_id"], name: "index_mistakes_on_journal_correction_id"
    t.index ["journal_id"], name: "index_mistakes_on_journal_id"
    t.index ["user_id"], name: "index_mistakes_on_user_id"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.time "notification_time"
    t.boolean "reminder_enabled", default: false
    t.integer "scene_type", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "line_friend", default: false, null: false
    t.string "line_link_code"
    t.boolean "line_notifications_enabled", default: false
    t.string "line_user_id"
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "journal_corrections", "journals"
  add_foreign_key "journal_corrections", "users"
  add_foreign_key "journals", "users"
  add_foreign_key "mistakes", "journal_corrections"
  add_foreign_key "mistakes", "journals"
  add_foreign_key "mistakes", "users"
  add_foreign_key "notification_settings", "users"
end
