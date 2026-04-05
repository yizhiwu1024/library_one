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

ActiveRecord::Schema[8.1].define(version: 2026_04_04_000500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "author", null: false
    t.integer "available_copies", default: 0, null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "isbn", null: false
    t.string "title", null: false
    t.integer "total_copies", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
    t.check_constraint "available_copies <= total_copies", name: "books_available_lte_total"
  end

  create_table "borrowings", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.date "borrowed_on", null: false
    t.datetime "created_at", null: false
    t.date "due_on", null: false
    t.integer "renewal_count", default: 0, null: false
    t.date "returned_on"
    t.string "status", default: "borrowed", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["book_id"], name: "index_borrowings_on_book_id"
    t.index ["user_id"], name: "index_borrowings_on_user_id"
    t.check_constraint "due_on >= borrowed_on", name: "borrowings_due_after_borrowed"
    t.check_constraint "renewal_count >= 0", name: "borrowings_renewal_nonnegative"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "user_profiles", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "full_name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "member", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "books", "categories"
  add_foreign_key "borrowings", "books"
  add_foreign_key "borrowings", "users"
  add_foreign_key "user_profiles", "users"
end
