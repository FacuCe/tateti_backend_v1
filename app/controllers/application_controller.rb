class ApplicationController < ActionController::API

  private

  def check_token
    return if current_user.present?
    render(json: format_error(request.path, 'Invalid token'), status: 401)
  end

  def format_error(path, message)
    { message: [{ path: path, message: message }] }
  end

  def header_token
    request.headers["Authorization"].split(" ").last
  end

  def current_user
    @current_user ||= User.find_by(token: header_token)
  end

  def current_user_game_player
    @current_user_game_player ||= UserGamePlayer.find_by(user_id: current_user)
  end

  def current_game
    @current_game ||= Game.joins()
  end
end
