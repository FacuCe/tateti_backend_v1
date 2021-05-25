class V1::GamesController < ApplicationController
    before_action :check_token, only: [:create, :play, :current, :index]

    def create
        # un user solo puede tener un juego activo (con game_over = false)

        # si hay un juego activo: lo devuelvo
        if current_game.present?
            render(json: {current_player: current_game.current_player, board: current_game.board, symbol: UserGamePlayer.find_by(user_id: current_user.id, game_id: current_game.id).player_symbol}, status: 200)
        else
            # sino, veo si otro user tiene un juego activo y lo devuelvo
            game_to_play = Game.find_by(players_complete: false)

            if game_to_play.present?
                # veo que el user de ese juego activo no sea yo mismo
                if game_to_play.users.first.id != current_user.id
                    game_to_play.update!(players_complete: true)
                    user_game_player = UserGamePlayer.new(player_symbol: "o")
                    user_game_player.game = game_to_play
                    user_game_player.user = current_user
                    user_game_player.save!
                    render(json: {current_player: game_to_play.current_player, board: game_to_play.board, symbol: user_game_player.player_symbol}, status: 200) 
                end
            else
                # sino, creo un nuevo juego
                user_game_player = UserGamePlayer.new(player_symbol: "x")
                new_game = Game.create!(board: Array.new(9, ""), players_complete: false)
                user_game_player.game = new_game
                user_game_player.user = current_user
                user_game_player.save!
                render(json: {current_player: new_game.current_player, board: new_game.board, symbol: user_game_player.player_symbol}, status: 200)
            end
        end
    end

    # viendo
    def play

        if current_game.blank?
            render(json: { msg: "no game found" }, status: 400)
        else
            user_game_player = UserGamePlayer.find_by(user_id: current_user.id, game_id: current_game.id)

            if user_game_player.player_symbol != current_game.current_player
                render(json: { msg: "it is not your turn"})
            elsif current_game.play(play_params[:square])
                current_game.save!
                render(json: current_game, status: :ok)
            else
                render(json: { msg: "the square selected is not empty" }, status: 400)
            end
        end
    end

    def current
        if current_game.present?
            render(json: current_game, status: 200)
        else
            render(json: current_user.games.last, status: 200)
        end
    end

    def index
        json = current_user.games.map do |game|
            game.index_json(current_user.id)
        end
        render(json: json, status: 200)
    end

    private

    def current_game
        @current_game ||= search_current_game
    end

    def search_current_game
        game_current = nil
        current_user.games.each do |game|
            game_current = game if game.game_over == false
        end
        return game_current
    end

    def play_params
        params.require(:movement).permit(:square)
    end
end
