Rails.application.routes.draw do
  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    confirmation: 'verification',
    unlock: 'unblock',
    registration: 'register',
    sign_up: 'sign-up',
  }

  resources :records
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :home, path: '' do
    collection do
      get :ui
      get :ui2
      get :refresh
    end
  end

  root 'home#index'
end
