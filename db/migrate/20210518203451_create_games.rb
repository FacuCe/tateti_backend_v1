class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :board, null: false
      t.boolean :players_complete, default: false # true with 2 users - false with 1 user
      t.string :current_player, null: false, limit: 1, default: "x"
      t.boolean :game_over, null: false, default: false
      t.boolean :tied_game, null: false, default: false
      t.string :winner, default: ""

      t.timestamps
    end
  end
end
