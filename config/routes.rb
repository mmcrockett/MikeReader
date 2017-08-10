Rails.application.routes.draw do
  root :to => redirect('/entries')

  resources :entries
  resources :feeds
end
