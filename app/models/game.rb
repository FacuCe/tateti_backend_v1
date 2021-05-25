class Game < ApplicationRecord
    serialize :board

    has_many :user_game_players # maximum: 2 user_games
    has_many :users, :through => :user_game_players # maximum: 2 users

    def play(square)
        return false unless self.board[square].empty?

        return false if !square.to_s.match?(/[0-8]/) || square.to_s.length != 1

        self.board[square] = self.current_player

        return true if check_winner
        
        return true if check_tied_game

        change_current_player
    end

    def change_current_player
        if self.current_player == "x"
            self.current_player = "o"
        else
            self.current_player = "x"
        end
    end

    def check_full_board
        check = true
        self.board.each do |square|
            check = false if square.empty?
        end
        return check
    end

    def check_winner
        ApplicationRecord.winner_pattern.each do |value|
            empty_value = false
            for i in 0..2 do
                empty_value = true if self.board[value[i]].empty?
            end
            next if empty_value
            if self.board[value[0]] == self.board[value[1]] && self.board[value[1]] == self.board[value[2]]
                self.game_over = true
                self.winner = self.current_player
                break
            end
        end
        self.game_over
    end

    def check_tied_game
        if check_full_board
            self.tied_game = true
            self.game_over = true
        end
        return self.tied_game
    end

    def json
        {current_player: current_player, board: board}
    end

    def index_json(id_user)
        users_list = []
        # en la primer posicion guardo la info del current_user y en la segunda posicion la info del oponente
        user_game_players.each do |ugp|
            if ugp.user_id == id_user
                users_list.insert(0, { user_id: ugp.user.id, login: ugp.user.login, player_symbol: ugp.player_symbol })
            else
                users_list.push({ user_id: ugp.user.id, login: ugp.user.login, player_symbol: ugp.player_symbol })
            end
        end
        {id: id, game_over: game_over, tied_game: tied_game, winner: winner, users: users_list}
    end
end
