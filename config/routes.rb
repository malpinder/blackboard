Blackboard::Application.routes.draw do

  get "users/:nickname", to: 'users#show', as: "user"
  delete "users/:nickname", to: 'users#destroy'

  get '/auth/:provider',          to: 'sessions#new', as: "new_session"
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/sessions',             to: "sessions#destroy", as: "session"

  resources :projects
  resources :user_projects, only: [:create, :update, :destroy]
  resources :goal_completions, only: [:create]

  root "blackboard#show"

end
