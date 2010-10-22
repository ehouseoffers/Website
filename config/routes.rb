Ehouseoffers::Application.routes.draw do
  devise_for :users

  resources :trends
  resources :spotlight, :as => :spotlighters
  resources :reasons_to_sell, :as => :reasons
  resources :guides
  resources :contact, :as => :contacts

  match '/about',    :to => 'home#about'
  # match '/site_map', :to => 'home#site_map'
  match '/terms',    :to => 'home#terms'
  # match '/contact',  :to => 'home#contact'

  root :to => 'home#welcome'
  match '/', :to => 'home#welcome', :as => 'home'
end
