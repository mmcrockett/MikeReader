Rails.application.routes.draw do
  root :to => redirect('/entries')

  resources :entries
  resources :feeds
  match 'pods',  :to => 'entries#pods', :via => [:get]
end
