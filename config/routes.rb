Cobweb::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: {
    registrations: "registrations"
  }
  resources :users

  resources :community_groups do
    get 'search', on: :collection
    resources :applications, controller: 'community_group_applications'
  end

  resources :buildings

  # Manage Cobweb routes
  namespace :manage do
    resources :groups, only: [ :index ]
    resources :retrofit_providers, only: [ :index ]
    resources :housing_providers, only: [ :index ]
  end

end
