Blackboard::Application.routes.draw do

  get '/auth/:provider',          to: 'sessions#new', as: "new_session"
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/sessions',             to: "sessions#destroy", as: "session"

  resources :projects

  root "blackboard#show"

end
