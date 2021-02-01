# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_31_175352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string "function"
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_assignments_on_company_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_companies_on_country_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "country_tax_codes", force: :cascade do |t|
    t.string "name"
    t.float "rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_country_tax_codes_on_country_id"
  end

  create_table "due_dates", force: :cascade do |t|
    t.date "begin_date"
    t.date "end_date"
    t.date "due_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "periodicity_to_project_type_id", null: false
    t.index ["periodicity_to_project_type_id"], name: "index_due_dates_on_periodicity_to_project_type_id"
  end

  create_table "entities", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "vat_number"
    t.bigint "country_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "postal_code"
    t.string "city"
    t.index ["company_id"], name: "index_entities_on_company_id"
    t.index ["country_id"], name: "index_entities_on_country_id"
  end

  create_table "entity_tax_codes", force: :cascade do |t|
    t.string "name"
    t.string "tax_code"
    t.bigint "country_tax_code_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_tax_code_id"], name: "index_entity_tax_codes_on_country_tax_code_id"
    t.index ["entity_id"], name: "index_entity_tax_codes_on_entity_id"
  end

  create_table "periodicities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "periodicity_to_project_types", force: :cascade do |t|
    t.bigint "project_type_id", null: false
    t.bigint "periodicity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_periodicity_to_project_types_on_country_id"
    t.index ["periodicity_id"], name: "index_periodicity_to_project_types_on_periodicity_id"
    t.index ["project_type_id"], name: "index_periodicity_to_project_types_on_project_type_id"
  end

  create_table "project_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "periodicity"
    t.bigint "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_projects_on_country_id"
  end

  create_table "returns", force: :cascade do |t|
    t.date "begin_date"
    t.date "end_date"
    t.bigint "country_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "due_date_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "periodicity_to_project_type_id", null: false
    t.index ["country_id"], name: "index_returns_on_country_id"
    t.index ["due_date_id"], name: "index_returns_on_due_date_id"
    t.index ["entity_id"], name: "index_returns_on_entity_id"
    t.index ["periodicity_to_project_type_id"], name: "index_returns_on_periodicity_to_project_type_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "invoice_number"
    t.date "invoice_date"
    t.string "tax_code"
    t.float "vat_amount"
    t.float "net_amount"
    t.float "total_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assignments", "companies"
  add_foreign_key "assignments", "users"
  add_foreign_key "companies", "countries"
  add_foreign_key "country_tax_codes", "countries"
  add_foreign_key "due_dates", "periodicity_to_project_types"
  add_foreign_key "entities", "companies"
  add_foreign_key "entities", "countries"
  add_foreign_key "entity_tax_codes", "country_tax_codes"
  add_foreign_key "entity_tax_codes", "entities"
  add_foreign_key "periodicity_to_project_types", "countries"
  add_foreign_key "periodicity_to_project_types", "periodicities"
  add_foreign_key "periodicity_to_project_types", "project_types"
  add_foreign_key "projects", "countries"
  add_foreign_key "returns", "countries"
  add_foreign_key "returns", "due_dates"
  add_foreign_key "returns", "entities"
  add_foreign_key "returns", "periodicity_to_project_types"
end
