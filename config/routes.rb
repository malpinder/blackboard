Blackboard::Application.routes.draw do

  get "users/:nickname", to: 'users#show', as: "user"

  get '/auth/:provider',          to: 'sessions#new', as: "new_session"
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/sessions',             to: "sessions#destroy", as: "session"

  resources :projects
  resources :user_projects, only: [:create, :destroy]

  root "blackboard#show"

end
