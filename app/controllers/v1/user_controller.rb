class V1::UserController < ApplicationController
    before_action :check_token,
    only: [
      :signout,
      :current,
      :password
    ]

    def create
        user = User.new(user_params)
    
        if user.save
          render(json: { token: user.token }, status: 200)
        else
          render(json: format_error(request.path, user.errors.full_messages), status: 401)
        end
    end

    def password
        if current_user.valid_password?(params["currentPassword"])
          if current_user.update(password: params["newPassword"])
            render(status: 200)
          else
            render(json: format_error(request.path, current_user.errors.full_messages), status: 401)
          end
        else
          render(json: format_error(request.path, 'Incorrect currentPassword'), status: 401)
        end
    end

    def signin
        user = User.find_by(login: user_params[:login])
    
        if user.present? && user.valid_password?(user_params[:password])
          # si hago logout se destruye el token y cuando hago login nunca creo el token
          user.set_token if user.token.nil?
          user.save!
          render(json: { token: user.token }, status: 200)
        else
          error = user.blank? ? 'Incorrect login' : 'Incorrect password'
          render(json: format_error(request.path, error), status: 401)
        end
    end

    def signout
        if current_user.remove_token
          render(status: 200)
        else
          render(json: format_error(request.path, current_user.errors.full_messages), status: 401)
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :login, :password)
    end
end
