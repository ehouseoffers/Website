Ehouseoffers::Application.routes.draw do

  devise_for :users
  # match '/users', :to => 'users#index'

  match '/admin', :to => 'admin#index'
  namespace :admin do
    resources :meta_datum
    resources :user_accounts
    match '/become/:id', :to => 'admin#become', :as => :become_user
  end

  resources :addresses
  resources :contact, :as => :contacts
  resources :phone_numbers

  resources :blogs do
    # 'Email this Image' form on 'You Should Sell When...' pages
    post :email_image, :on => :member
  end

  resources :bullet_points do
    collection do
      get '/edit/collection/:context/:context_id', :action => :edit_collection, :as => :edit_collection
    end
  end

  resources :qas do
    collection do
      get '/edit/collection/:context/:context_id', :action => :edit_collection, :as => :edit_collection
    end
  end

  match '/home-offer-1', :as => :new_home_offer, :to => 'seller_listings#new'
  match '/home-offer-2/:id', :as => :home_offer_2, :to => 'seller_listings#homeoffer2'
  match '/home-offer-3', :as => :home_offer_3, :to => 'seller_listings#homeoffer3'
  resources 'home-offer', :as => :seller_listings, :controller => :seller_listings  do
    # get :homeoffer2, :on => :member # Registration 2nd step form display
    # get :homeoffer3, :on => :member # Registration confirmation/appreciation
  end

  resources :social_profiles do
    collection do
      get '/edit/collection/:context/:context_id', :action => :edit_collection, :as => :edit_collection
    end
  end

  match '/how-to-sell-house', :as => :guides_seo, :to => 'guides#index'
  resources 'g',  :as => :guides,  :controller => :guides

  match '/real-estate-spotlight', :as => :spotlights_seo, :to => 'spotlights#index'
  resources 's', :as => :spotlights, :controller => :spotlights

  match '/sell-my-house', :as => :reasons_seo, :to => 'blogs#index'
  resources 'r', :as => :reasons, :controller => :blogs

  match '/real-estate-trends', :as => :trends_seo, :to => 'blogs#index'
  resources 't', :as => :trends,  :controller => :blogs

  match '/become-a-home-buyer', :as => :become_a_buyer, :to => 'home#become_a_buyer'
  match '/we-buy-houses',       :as => :about,          :to => 'home#about'
  match '/terms-of-service',    :as => :terms,          :to => 'home#terms'

  match '/generate-url-friendly-string', :as => 'generate_url_friendly_string', :to => 'home#generate_url_friendly_string'
  match '/what-we-do', :as => 'what_we_do', :to => 'home#what_we_do'

  root :to => 'home#home'
  match '/', :to => 'home#home', :as => 'home_seo'

  # Ajax Only
  match '/pfz', :to => 'ajax#placefinder_by_zip', :as => 'placefinder_by_zip'
end
