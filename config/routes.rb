Blackboard::Application.routes.draw do
  resources :projects

  root "blackboard#show"

end
