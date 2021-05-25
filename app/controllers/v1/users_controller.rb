class V1::UsersController < ApplicationController
  before_action :check_token,
    only: [
      :current
    ]

  # listo
  def current
    render(json: current_user.json, status: 200)
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :login, :password)
  end
end
