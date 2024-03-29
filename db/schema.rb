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

ActiveRecord::Schema.define(version: 2022_01_16_123440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accesses", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "amounts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "assignments", force: :cascade do |t|
    t.string "function"
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_assignments_on_company_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "box_logics", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "amount_id", null: false
    t.bigint "tax_code_operation_location_id", null: false
    t.bigint "tax_code_operation_rate_id", null: false
    t.bigint "tax_code_operation_side_id", null: false
    t.bigint "tax_code_operation_type_id", null: false
    t.bigint "box_id"
    t.bigint "operation_type_id"
    t.bigint "document_type_id"
    t.index ["amount_id"], name: "index_box_logics_on_amount_id"
    t.index ["box_id"], name: "index_box_logics_on_box_id"
    t.index ["document_type_id"], name: "index_box_logics_on_document_type_id"
    t.index ["operation_type_id"], name: "index_box_logics_on_operation_type_id"
    t.index ["tax_code_operation_location_id"], name: "index_box_logics_on_tax_code_operation_location_id"
    t.index ["tax_code_operation_rate_id"], name: "index_box_logics_on_tax_code_operation_rate_id"
    t.index ["tax_code_operation_side_id"], name: "index_box_logics_on_tax_code_operation_side_id"
    t.index ["tax_code_operation_type_id"], name: "index_box_logics_on_tax_code_operation_type_id"
  end

  create_table "box_name_languages", force: :cascade do |t|
    t.bigint "box_id", null: false
    t.bigint "language_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["box_id"], name: "index_box_name_languages_on_box_id"
    t.index ["language_id"], name: "index_box_name_languages_on_language_id"
  end

  create_table "boxes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "periodicity_id"
    t.bigint "country_id"
    t.bigint "project_type_id"
    t.index ["country_id"], name: "index_boxes_on_country_id"
    t.index ["periodicity_id"], name: "index_boxes_on_periodicity_id"
    t.index ["project_type_id"], name: "index_boxes_on_project_type_id"
  end

  create_table "cloudinary_photos", force: :cascade do |t|
    t.string "api_key"
    t.bigint "invoice_id", null: false
    t.string "secure_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["invoice_id"], name: "index_cloudinary_photos_on_invoice_id"
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
    t.integer "is_eu"
  end

  create_table "country_rates", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.bigint "tax_code_operation_rate_id", null: false
    t.float "rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_country_rates_on_country_id"
    t.index ["tax_code_operation_rate_id"], name: "index_country_rates_on_tax_code_operation_rate_id"
  end

  create_table "country_tax_codes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id", null: false
    t.bigint "tax_code_operation_location_id", null: false
    t.bigint "tax_code_operation_side_id", null: false
    t.bigint "tax_code_operation_type_id", null: false
    t.bigint "tax_code_operation_rate_id", null: false
    t.index ["country_id"], name: "index_country_tax_codes_on_country_id"
    t.index ["tax_code_operation_location_id"], name: "index_country_tax_codes_on_tax_code_operation_location_id"
    t.index ["tax_code_operation_rate_id"], name: "index_country_tax_codes_on_tax_code_operation_rate_id"
    t.index ["tax_code_operation_side_id"], name: "index_country_tax_codes_on_tax_code_operation_side_id"
    t.index ["tax_code_operation_type_id"], name: "index_country_tax_codes_on_tax_code_operation_type_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "vat_number"
    t.string "street"
    t.string "city"
    t.string "post_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "country_id", null: false
    t.bigint "entity_id", null: false
    t.index ["country_id"], name: "index_customers_on_country_id"
    t.index ["entity_id"], name: "index_customers_on_entity_id"
  end

  create_table "document_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "due_dates", force: :cascade do |t|
    t.date "begin_date"
    t.date "end_date"
    t.date "due_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "periodicity_id"
    t.bigint "project_type_id"
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_due_dates_on_country_id"
    t.index ["periodicity_id"], name: "index_due_dates_on_periodicity_id"
    t.index ["project_type_id"], name: "index_due_dates_on_project_type_id"
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
    t.string "phone_number"
    t.string "email"
    t.string "website"
    t.string "iban"
    t.string "bic"
    t.bigint "periodicity_id"
    t.index ["company_id"], name: "index_entities_on_company_id"
    t.index ["country_id"], name: "index_entities_on_country_id"
    t.index ["periodicity_id"], name: "index_entities_on_periodicity_id"
  end

  create_table "entity_tax_codes", force: :cascade do |t|
    t.string "name"
    t.bigint "country_tax_code_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_reverse_charge"
    t.boolean "is_benefit_in_kind"
    t.boolean "is_exempt_supply_article_44"
    t.boolean "is_hidden"
    t.index ["country_tax_code_id"], name: "index_entity_tax_codes_on_country_tax_code_id"
    t.index ["entity_id"], name: "index_entity_tax_codes_on_entity_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.date "invoice_date"
    t.date "payment_date"
    t.string "invoice_number"
    t.bigint "customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invoice_name"
    t.bigint "entity_id", null: false
    t.boolean "is_paid"
    t.bigint "tax_code_operation_side_id"
    t.bigint "tax_code_operation_location_id"
    t.bigint "document_type_id", null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["document_type_id"], name: "index_invoices_on_document_type_id"
    t.index ["entity_id"], name: "index_invoices_on_entity_id"
    t.index ["tax_code_operation_location_id"], name: "index_invoices_on_tax_code_operation_location_id"
    t.index ["tax_code_operation_side_id"], name: "index_invoices_on_tax_code_operation_side_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "item_name"
    t.string "item_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "entity_id", null: false
    t.float "net_amount"
    t.float "vat_amount"
    t.bigint "tax_code_operation_rate_id"
    t.bigint "tax_code_operation_type_id"
    t.boolean "is_hidden"
    t.index ["entity_id"], name: "index_items_on_entity_id"
    t.index ["tax_code_operation_rate_id"], name: "index_items_on_tax_code_operation_rate_id"
    t.index ["tax_code_operation_type_id"], name: "index_items_on_tax_code_operation_type_id"
  end

  create_table "language_countries", force: :cascade do |t|
    t.bigint "country_id"
    t.bigint "language_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_language_countries_on_country_id"
    t.index ["language_id"], name: "index_language_countries_on_language_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "operation_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "periodicities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "project_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "return_boxes", force: :cascade do |t|
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "return_id", null: false
    t.bigint "box_id", null: false
    t.index ["box_id"], name: "index_return_boxes_on_box_id"
    t.index ["return_id"], name: "index_return_boxes_on_return_id"
  end

  create_table "returns", force: :cascade do |t|
    t.date "begin_date"
    t.date "end_date"
    t.bigint "country_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "due_date_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "periodicity_id"
    t.bigint "project_type_id"
    t.index ["country_id"], name: "index_returns_on_country_id"
    t.index ["due_date_id"], name: "index_returns_on_due_date_id"
    t.index ["entity_id"], name: "index_returns_on_entity_id"
    t.index ["periodicity_id"], name: "index_returns_on_periodicity_id"
    t.index ["project_type_id"], name: "index_returns_on_project_type_id"
  end

  create_table "tax_code_operation_locations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tax_code_operation_rates", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "rate"
  end

  create_table "tax_code_operation_sides", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tax_code_operation_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ticket_to_tax_codes", force: :cascade do |t|
    t.bigint "tax_code_operation_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["tax_code_operation_type_id"], name: "index_ticket_to_tax_codes_on_tax_code_operation_type_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.float "vat_amount"
    t.float "net_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "return_id", null: false
    t.bigint "invoice_id"
    t.string "comment"
    t.float "quantity"
    t.bigint "item_id"
    t.bigint "tax_code_operation_rate_id"
    t.index ["invoice_id"], name: "index_transactions_on_invoice_id"
    t.index ["item_id"], name: "index_transactions_on_item_id"
    t.index ["return_id"], name: "index_transactions_on_return_id"
    t.index ["tax_code_operation_rate_id"], name: "index_transactions_on_tax_code_operation_rate_id"
  end

  create_table "user_access_companies", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "user_id", null: false
    t.bigint "access_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_id"], name: "index_user_access_companies_on_access_id"
    t.index ["company_id"], name: "index_user_access_companies_on_company_id"
    t.index ["user_id"], name: "index_user_access_companies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "language_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["language_id"], name: "index_users_on_language_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignments", "companies"
  add_foreign_key "assignments", "users"
  add_foreign_key "box_logics", "amounts"
  add_foreign_key "box_logics", "boxes"
  add_foreign_key "box_logics", "document_types"
  add_foreign_key "box_logics", "operation_types"
  add_foreign_key "box_logics", "tax_code_operation_locations"
  add_foreign_key "box_logics", "tax_code_operation_rates"
  add_foreign_key "box_logics", "tax_code_operation_sides"
  add_foreign_key "box_logics", "tax_code_operation_types"
  add_foreign_key "box_name_languages", "boxes"
  add_foreign_key "box_name_languages", "languages"
  add_foreign_key "boxes", "countries"
  add_foreign_key "boxes", "periodicities"
  add_foreign_key "boxes", "project_types"
  add_foreign_key "cloudinary_photos", "invoices"
  add_foreign_key "companies", "countries"
  add_foreign_key "country_rates", "countries"
  add_foreign_key "country_rates", "tax_code_operation_rates"
  add_foreign_key "country_tax_codes", "countries"
  add_foreign_key "country_tax_codes", "tax_code_operation_locations"
  add_foreign_key "country_tax_codes", "tax_code_operation_rates"
  add_foreign_key "country_tax_codes", "tax_code_operation_sides"
  add_foreign_key "country_tax_codes", "tax_code_operation_types"
  add_foreign_key "customers", "countries"
  add_foreign_key "customers", "entities"
  add_foreign_key "due_dates", "countries"
  add_foreign_key "due_dates", "periodicities"
  add_foreign_key "due_dates", "project_types"
  add_foreign_key "entities", "companies"
  add_foreign_key "entities", "countries"
  add_foreign_key "entities", "periodicities"
  add_foreign_key "entity_tax_codes", "country_tax_codes"
  add_foreign_key "entity_tax_codes", "entities"
  add_foreign_key "invoices", "document_types"
  add_foreign_key "invoices", "entities"
  add_foreign_key "invoices", "tax_code_operation_locations"
  add_foreign_key "invoices", "tax_code_operation_sides"
  add_foreign_key "items", "entities"
  add_foreign_key "items", "tax_code_operation_rates"
  add_foreign_key "items", "tax_code_operation_types"
  add_foreign_key "language_countries", "languages"
  add_foreign_key "return_boxes", "boxes"
  add_foreign_key "return_boxes", "returns"
  add_foreign_key "returns", "countries"
  add_foreign_key "returns", "due_dates"
  add_foreign_key "returns", "entities"
  add_foreign_key "returns", "periodicities"
  add_foreign_key "returns", "project_types"
  add_foreign_key "ticket_to_tax_codes", "tax_code_operation_types"
  add_foreign_key "transactions", "invoices"
  add_foreign_key "transactions", "items"
  add_foreign_key "transactions", "returns"
  add_foreign_key "transactions", "tax_code_operation_rates"
  add_foreign_key "user_access_companies", "accesses"
  add_foreign_key "user_access_companies", "companies"
  add_foreign_key "user_access_companies", "users"
  add_foreign_key "users", "languages"
end
