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

    resources :activities, only: [:index, :new, :create]
    namespace "activities", module: nil, as: nil do
      get    ":type"          => "activities#index", as: :activities_by_type
      get    ":type/new"      => "activities#new",   as: :new_activity_by_type
      post   ":type"          => "activities#create"
      get    ":type/:id"      => "activities#show",  as: :activity
      get    ":type/:id/edit" => "activities#edit",  as: :edit_activity
      put    ":type/:id"      => "activities#update"
      patch  ":type/:id"      => "activities#update"
      delete ":type/:id"      => "activities#destroy"
    end
  end

  root to: "events#index"
end
