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

ActiveRecord::Schema.define(version: 2019_03_21_175331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_categories_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "ignored_transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "plaid_transaction_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ignored_transactions_on_user_id"
  end

  create_table "plaid_accounts", force: :cascade do |t|
    t.bigint "plaid_item_id"
    t.string "account_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plaid_item_id"], name: "index_plaid_accounts_on_plaid_item_id"
  end

  create_table "plaid_categories", force: :cascade do |t|
    t.string "category_id"
    t.bigint "sub_category_id"
    t.text "hierarchy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_plaid_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_plaid_categories_on_sub_category_id"
  end

  create_table "plaid_imports", force: :cascade do |t|
    t.string "plaid_item_id"
    t.jsonb "data"
    t.string "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plaid_items", force: :cascade do |t|
    t.bigint "user_id"
    t.string "item_id"
    t.string "access_token"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_plaid_items_on_user_id"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name"
    t.decimal "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "name"], name: "index_sub_categories_on_category_id_and_name", unique: true
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.string "name"
    t.decimal "amount"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recurring", default: false
    t.string "plaid_transaction_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["sub_category_id"], name: "index_transactions_on_sub_category_id"
    t.index ["user_id", "plaid_transaction_id"], name: "index_transactions_on_user_id_and_plaid_transaction_id", unique: true
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_manager", default: true
    t.integer "manager_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
