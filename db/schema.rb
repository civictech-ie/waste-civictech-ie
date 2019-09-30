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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2019_09_30_121305) do
=======
ActiveRecord::Schema.define(version: 2019_09_24_230020) do
>>>>>>> master

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bin_bag_retailers", force: :cascade do |t|
    t.text "name"
    t.text "address"
    t.text "postcode"
    t.text "google_map_url"
    t.boolean "google_map_has_opening_hours"
    t.text "providers", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

<<<<<<< HEAD
  create_table "provider_streets", force: :cascade do |t|
    t.bigint "street_id", null: false
    t.bigint "provider_id", null: false
    t.integer "collection_start"
    t.integer "collection_duration"
    t.text "collection_days", default: [], array: true
    t.integer "presentation_start"
    t.integer "presentation_duration"
    t.text "presentation_days", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_provider_streets_on_provider_id"
    t.index ["street_id"], name: "index_provider_streets_on_street_id"
  end

  create_table "providers", force: :cascade do |t|
    t.text "name", null: false
    t.text "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_providers_on_slug", unique: true
  end

=======
>>>>>>> master
  create_table "streets", force: :cascade do |t|
    t.text "name"
    t.text "slug"
    t.text "postcode"
    t.boolean "bag_street", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "display_name"
    t.text "collection_days", default: [], array: true
    t.integer "collection_start"
    t.integer "collection_duration"
    t.text "presentation_days", default: [], array: true
    t.integer "presentation_start"
    t.integer "presentation_duration"
    t.index "to_tsvector('english'::regconfig, display_name)", name: "streets_display_name", using: :gin
    t.index ["bag_street"], name: "index_streets_on_bag_street"
    t.index ["name"], name: "index_streets_on_name"
    t.index ["postcode"], name: "index_streets_on_postcode"
    t.index ["slug"], name: "index_streets_on_slug", unique: true
  end

  add_foreign_key "provider_streets", "providers"
  add_foreign_key "provider_streets", "streets"
end
