# POST /v1/user/password => Cambiar password

# GET  /v1/users
# POST /v1/users/signin
# GET  /v1/users/signout
# POST /v1/users
# GET  /v1/users/current
# POST /v1/users/newgame       # recibo token y regreso juego nuevo o existente
# POST /v1/users/playgame

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :v1, default: { format: :json } do
    resources :user, only: [:create] do
      collection do
        post :password
        get :signout
        post :signin
      end
    end
    resources :users, only: [] do
      collection do
        get :current
      end
    end
    resources :games, only: [:create, :index] do
      collection do
        post :play
        get :current
      end
    end
  end
end
