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

  resources :buildings do
    get 'search', on: :collection
  end
  resources :building_groups
  resources :explorations, only: [:index]

  # Manage Cobweb routes
  namespace :manage do
    resources :community_groups, only: [ :index ]
    resources :retrofit_providers, only: [ :index ]
    resources :housing_providers, only: [ :index ]
    resources :buildings, only: [ :index ]
  end

end
