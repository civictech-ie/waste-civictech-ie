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

ActiveRecord::Schema.define(version: 2019_08_18_182200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

end
