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

ActiveRecord::Schema[8.0].define(version: 2025_02_16_085559) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clock_dailies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.date "date", null: false
    t.integer "total_duration", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "date"], name: "index_clock_dailies_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_clock_dailies_on_user_id"
  end

  create_table "clocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.datetime "clock_in"
    t.datetime "clock_out"
    t.integer "duration", default: -1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "clock_in", "clock_out"], name: "index_clocks_on_user_id_and_clock_in_and_clock_out", unique: true, where: "((clock_in IS NULL) AND (clock_out IS NULL))"
    t.index ["user_id", "clock_in"], name: "index_clocks_on_user_id_and_clock_in", unique: true, where: "(clock_in IS NULL)"
    t.index ["user_id", "clock_out"], name: "index_clocks_on_user_id_and_clock_out", unique: true, where: "(clock_out IS NULL)"
    t.index ["user_id"], name: "index_clocks_on_user_id"
  end

  create_table "follows", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "follower_id", null: false
    t.uuid "followee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_follows_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_follows_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "clock_dailies", "users"
  add_foreign_key "clocks", "users"
  add_foreign_key "follows", "users", column: "followee_id"
  add_foreign_key "follows", "users", column: "follower_id"
end
