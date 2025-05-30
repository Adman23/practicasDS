Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # Se redirige al login

  namespace :api do
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get 'retrieve_user', to: "users#retrieve_user"

    resources :users, only: [:create, :index, :show, :destroy] do # GETs de index y show para ver todos los users y ver uno solo
      get 'groups', on: :member # El get para /api/users/id/groups -> grupos de un usuario
      post 'groups', action: :create_group, on: :member # El post para /users/id/groups
      delete 'groups/:group_id', action: :destroy_group, on: :member # El delete para /users/id/groups/id -> Borrar un grupo de un usuario
    end

    resources :groups, only: [:index, :show, :update, :destroy] do # Operaciones de group
      get 'users', on: :member # El get para /api/groups/id/users -> Usuarios de un grupo
      post 'users', action: :add_user, on: :member # El post para /api/groups/id/users -> Añadir un usuario, no lo crea
      delete 'users/:user_id', action: :remove_user, on: :member # El delete para /api/groups/id/users/id
                                                                # Aqui (no deberia) borrarlos, simplemente borra el membership

      # Esto deberían de ser las operaciones de expense, pero anidadas a group, es decir, siempre son de un group
      resources :expenses, only: [:index, :show, :create, :update, :destroy]
    end
  end

end
