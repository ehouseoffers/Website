Ehouseoffers::Application.routes.draw do

  devise_for :users

  resources :addresses
  resources :contact, :as => :contacts
  resources :guides
  resources :phone_numbers

  # resources "reasons-to-sell", :as => :reasons do
  resources :reasons_to_sell, :as => :reasons do
    post :email_image, :on => :member # 'Email this Image' form on 'You Should Sell When...' pages
  end
  resources :seller_listings do
    get :comp_data, :on => :member # Registration 2nd step form display
    get :thank_you, :on => :member # Registration confirmation/appreciation
  end
  resources :spotlight, :as => :spotlighters
  resources :trends

  match '/about', :to => 'home#about'
  match '/terms_of_service', :to => 'home#terms', :as => 'terms'

  match '/generate_url_friendly_string', :to => 'home#generate_url_friendly_string'
  match '/what_we_do', :to => 'home#what_we_do'
  root :to => 'home#home'
  match '/', :to => 'home#home', :as => 'home'
end
