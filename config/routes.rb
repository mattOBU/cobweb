Cobweb::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, controllers: {
    registrations: "registrations"
  }
  resources :users
  resources :projects do
    get 'search', on: :collection
    resources :applications, controller: 'project_applications'
  end

  resources :properties

end
