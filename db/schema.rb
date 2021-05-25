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

ActiveRecord::Schema.define(version: 2021_05_18_203748) do

  create_table "games", force: :cascade do |t|
    t.string "board", null: false
    t.boolean "players_complete", default: false
    t.string "current_player", limit: 1, default: "x", null: false
    t.boolean "game_over", default: false, null: false
    t.boolean "tied_game", default: false, null: false
    t.string "winner", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_game_players", force: :cascade do |t|
    t.string "player_symbol", limit: 1, default: "x", null: false
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_user_game_players_on_game_id"
    t.index ["user_id"], name: "index_user_game_players_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.string "password"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "user_game_players", "games"
  add_foreign_key "user_game_players", "users"
end
