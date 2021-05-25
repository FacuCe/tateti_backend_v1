class UserGamePlayer < ApplicationRecord
    belongs_to :game
    belongs_to :user

    validates :player_symbol, presence: true
end
