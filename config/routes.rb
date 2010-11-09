Ehouseoffers::Application.routes.draw do
  resources :addresses

  resources :phone_numbers

  devise_for :users

  resources :contact, :as => :contacts
  resources :guides
  resources :reasons_to_sell, :as => :reasons
  resources :seller_listings do
    get :comp_data, :on => :member # Registration 2nd step form display
    get :thank_you, :on => :member # Registration confirmation/appreciation
  end
  resources :spotlight, :as => :spotlighters
  resources :trends

  match '/about', :to => 'home#about'
  match '/terms_of_service', :to => 'home#terms', :as => 'terms'

  match '/what_we_do', :to => 'home#what_we_do'
  root :to => 'home#home'
  match '/', :to => 'home#home', :as => 'home'
end
