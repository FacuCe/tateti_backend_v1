class CreateUserGamePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :user_game_players do |t|
      t.string :player_symbol, null: false, limit: 1, default: "x"
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
