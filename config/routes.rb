Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :posts
  resources :pages, param: :id
  resources :links

  resource :profile, only: [ :show, :update ], controller: "profile" do
    patch :password, to: "profile#update_password", as: :password
    post :reset_token, to: "profile#reset_token"
  end

  get "posts/tags/:id", to: "tags#show", as: "tag"
  get "up" => "rails/health#show", as: :rails_health_check
  get "about", to: "static_pages#about"
  get "charliemurphy", to: redirect("/session/new")
  root "posts#index"

  # Dynamic pages - must be last to avoid conflicts
  get ":slug", to: "pages#show", as: :public_page, constraints: { slug: /[a-z0-9-]+/ }
end
