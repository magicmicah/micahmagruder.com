Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :posts
  get "posts/tags/:id", to: "tags#show", as: "tag"
  get "up" => "rails/health#show", as: :rails_health_check
  get "about", to: "static_pages#about"
  get "charliemurphy", to: redirect("/session/new")
  root "posts#index"
end
