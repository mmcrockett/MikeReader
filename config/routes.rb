Rails.application.routes.draw do
  resources :entries, only: [:index, :destroy] do
    collection do
      get :pods
    end
  end

  resources :feeds, only: [:index, :update, :create]
end
