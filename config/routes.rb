Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      omniauth_callbacks: "omniauth_callbacks",
      registrations:      "user_registrations"
    }

  authenticate :user do
    resources :users
    match "/users/:id/finish_signup" => "users#finish_signup",
      via: [:get, :patch], :as => :finish_signup
  end

  resources :events do
    get "register/:package_slug" => "registrations#register",
      as: :package_registration
    get "register" => "registrations#register", as: :registration
    post "register" => "registrations#register"
  end

  root to: "events#index"
end
