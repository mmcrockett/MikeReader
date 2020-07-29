Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    resources :entries, only: [:index, :destroy] do
      collection do
        get :pods
      end
    end

    resources :feeds, only: [:index, :update, :create]
  end

  get "*path", to: "home#index", constraints: { format: "html" }
end
