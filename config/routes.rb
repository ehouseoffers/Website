Ehouseoffers::Application.routes.draw do
  devise_for :users

  get "home/welcome"

  match '/about',    :to => 'home#about'
  match '/site_map', :to => 'home#site_map'
  match '/terms',    :to => 'home#terms'
  match '/contact',  :to => 'home#contact'

  root :to => 'home#welcome'
end
