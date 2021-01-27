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

ActiveRecord::Schema.define(version: 2021_01_27_120134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counties", force: :cascade do |t|
    t.bigint "region_id"
    t.string "name"
    t.integer "moms_count", default: 0, null: false
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.string "external_id"
    t.integer "vaccs_count", default: 0, null: false
    t.index ["external_id"], name: "index_counties_on_external_id", unique: true
    t.index ["region_id"], name: "index_counties_on_region_id"
  end

  create_table "latest_test_date_snapshots", force: :cascade do |t|
    t.bigint "mom_id", null: false
    t.bigint "test_date_id", null: false
    t.bigint "test_date_snapshot_id"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.boolean "enabled", default: true, null: false
    t.index ["enabled"], name: "index_latest_test_date_snapshots_on_enabled"
    t.index ["mom_id", "test_date_id"], name: "index_latest_test_date_snapshots_on_mom_id_and_test_date_id", unique: true
    t.index ["mom_id"], name: "index_latest_test_date_snapshots_on_mom_id"
    t.index ["test_date_id"], name: "index_latest_test_date_snapshots_on_test_date_id"
    t.index ["test_date_snapshot_id"], name: "index_latest_test_date_snapshots_on_test_date_snapshot_id"
  end

  create_table "latest_vaccination_date_snapshots", force: :cascade do |t|
    t.bigint "vacc_id", null: false
    t.bigint "vaccination_date_id", null: false
    t.bigint "vaccination_date_snapshot_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true, null: false
    t.index ["enabled"], name: "index_latest_vaccination_date_snapshots_on_enabled"
    t.index ["vacc_id", "vaccination_date_id"], name: "idx_latest_vaccination_date_snapshots__unique_vacc_id_vdate_id", unique: true
    t.index ["vacc_id"], name: "index_latest_vaccination_date_snapshots__vacc_id"
    t.index ["vaccination_date_id"], name: "index_latest_vaccination_date_snapshots__date_id"
    t.index ["vaccination_date_snapshot_id"], name: "index_latest_vaccination_date_snapshots__date_snapshot_id"
  end

  create_table "moms", force: :cascade do |t|
    t.string "title"
    t.float "longitude"
    t.float "latitude"
    t.string "city"
    t.string "street_name"
    t.string "street_number"
    t.string "postal_code"
    t.bigint "region_id"
    t.string "region_name"
    t.bigint "county_id"
    t.string "county_name"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.bigint "latest_test_date_snapshot_id"
    t.string "type", default: "NcziMom", null: false
    t.string "reservations_url"
    t.string "external_id"
    t.string "external_endpoint"
    t.boolean "supports_reservation", default: true, null: false
    t.jsonb "external_details"
    t.boolean "enabled", default: true, null: false
    t.index ["city"], name: "index_moms_on_city"
    t.index ["county_id"], name: "index_moms_on_county_id"
    t.index ["county_name"], name: "index_moms_on_county_name"
    t.index ["enabled"], name: "index_moms_on_enabled"
    t.index ["external_endpoint"], name: "index_moms_on_external_endpoint"
    t.index ["external_id"], name: "index_moms_on_external_id", unique: true
    t.index ["latest_test_date_snapshot_id"], name: "index_moms_on_latest_test_date_snapshot_id"
    t.index ["latitude"], name: "index_moms_on_latitude"
    t.index ["longitude"], name: "index_moms_on_longitude"
    t.index ["postal_code"], name: "index_moms_on_postal_code"
    t.index ["region_id"], name: "index_moms_on_region_id"
    t.index ["region_name"], name: "index_moms_on_region_name"
    t.index ["supports_reservation"], name: "index_moms_on_supports_reservation"
    t.index ["title"], name: "index_moms_on_title"
    t.index ["type"], name: "index_moms_on_type"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.integer "moms_count", default: 0, null: false
    t.string "external_id"
    t.integer "vaccs_count", default: 0, null: false
    t.index ["external_id"], name: "index_regions_on_external_id", unique: true
  end

  create_table "test_date_snapshots", force: :cascade do |t|
    t.bigint "mom_id", null: false
    t.bigint "test_date_id", null: false
    t.boolean "is_closed", null: false
    t.integer "free_capacity", default: 0, null: false
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.index ["created_at"], name: "index_test_date_snapshots_on_created_at"
    t.index ["free_capacity"], name: "index_test_date_snapshots_on_free_capacity"
    t.index ["is_closed"], name: "index_test_date_snapshots_on_is_closed"
    t.index ["mom_id"], name: "index_test_date_snapshots_on_mom_id"
    t.index ["test_date_id"], name: "index_test_date_snapshots_on_test_date_id"
  end

  create_table "test_dates", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.index ["date"], name: "index_test_dates_on_date"
  end

  create_table "vaccination_date_snapshots", force: :cascade do |t|
    t.bigint "vacc_id", null: false
    t.bigint "vaccination_date_id", null: false
    t.boolean "is_closed", null: false
    t.integer "free_capacity", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_vaccination_date_snapshots_on_created_at"
    t.index ["free_capacity"], name: "index_vaccination_date_snapshots_on_free_capacity"
    t.index ["is_closed"], name: "index_vaccination_date_snapshots_on_is_closed"
    t.index ["vacc_id"], name: "index_vaccination_date_snapshots_on_vacc_id"
    t.index ["vaccination_date_id"], name: "index_vaccination_date_snapshots_on_vaccination_date_id"
  end

  create_table "vaccination_dates", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_vaccination_dates_on_date"
  end

  create_table "vaccs", force: :cascade do |t|
    t.string "type", default: "NcziVacc", null: false
    t.string "external_id"
    t.string "title"
    t.float "longitude"
    t.float "latitude"
    t.string "city"
    t.string "street_name"
    t.string "street_number"
    t.string "postal_code"
    t.bigint "region_id"
    t.bigint "county_id"
    t.string "reservations_url"
    t.datetime "created_at", precision: 6, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "now()" }, null: false
    t.boolean "enabled", default: true, null: false
    t.index ["city"], name: "index_vaccs_on_city"
    t.index ["county_id"], name: "index_vaccs_on_county_id"
    t.index ["enabled"], name: "index_vaccs_on_enabled"
    t.index ["external_id"], name: "index_vaccs_on_external_id", unique: true
    t.index ["latitude"], name: "index_vaccs_on_latitude"
    t.index ["longitude"], name: "index_vaccs_on_longitude"
    t.index ["postal_code"], name: "index_vaccs_on_postal_code"
    t.index ["region_id"], name: "index_vaccs_on_region_id"
    t.index ["type"], name: "index_vaccs_on_type"
  end

  add_foreign_key "counties", "regions", on_delete: :restrict
  add_foreign_key "latest_test_date_snapshots", "moms", on_delete: :restrict
  add_foreign_key "latest_test_date_snapshots", "test_date_snapshots", on_delete: :nullify
  add_foreign_key "latest_test_date_snapshots", "test_dates", on_delete: :restrict
  add_foreign_key "latest_vaccination_date_snapshots", "vaccination_date_snapshots", on_delete: :nullify
  add_foreign_key "latest_vaccination_date_snapshots", "vaccination_dates", on_delete: :restrict
  add_foreign_key "latest_vaccination_date_snapshots", "vaccs", on_delete: :restrict
  add_foreign_key "moms", "latest_test_date_snapshots", on_delete: :nullify
  add_foreign_key "test_date_snapshots", "moms", on_delete: :restrict
  add_foreign_key "test_date_snapshots", "test_dates", on_delete: :restrict
  add_foreign_key "vaccination_date_snapshots", "vaccination_dates", on_delete: :restrict
  add_foreign_key "vaccination_date_snapshots", "vaccs", on_delete: :restrict
  add_foreign_key "vaccs", "counties", on_delete: :restrict
  add_foreign_key "vaccs", "regions", on_delete: :restrict
end
