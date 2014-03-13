Cobweb::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: {
    registrations: "registrations"
  }
  resources :users

  get 'role/:role', to: 'roles#switch', as: :switch_role

  resources :community_groups do
    get 'search', on: :collection
    resources :applications, controller: 'community_group_applications'
  end

  resources :buildings do
    get 'search', on: :collection
    resources :building_energy_profiles, except: [ :new ]
  end
  resources :building_groups do
    get 'search', on: :collection
  end

  namespace :explore do
    resources :buildings, only: [:index, :create]
    resources :building_groups, only: [:index, :create]
    resources :community_groups, only: [:index, :create]
  end

  # Manage Cobweb routes
  namespace :manage do
    resources :community_groups, only: [ :index ]
    resources :retrofit_providers, only: [ :index ]
    resources :housing_providers, only: [ :index ]
    resources :buildings, only: [ :index ]
  end

end
