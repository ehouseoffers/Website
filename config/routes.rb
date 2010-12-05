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

  resources :seller_listings do
    get :comp_data, :on => :member # Registration 2nd step form display
    get :thank_you, :on => :member # Registration confirmation/appreciation
  end

  resources :social_profiles do
    collection do
      get '/edit/collection/:context/:context_id', :action => :edit_collection, :as => :edit_collection
    end
  end

  resources '/real-estate-spotlight', :as => :spotlights, :controller => :spotlights
  resources 'how-to-sell-house',  :as => :guides,  :controller => :guides
  resources 'sell-my-house',      :as => :reasons, :controller => :blogs
  resources 'real-estate-trends', :as => :trends,  :controller => :blogs

  match '/we-buy-houses', :as => :about, :to => 'home#about'
  match '/terms-of-service', :as => :terms, :to => 'home#terms'

  match '/generate-url-friendly-string', :as => 'generate_url_friendly_string', :to => 'home#generate_url_friendly_string'
  match '/what-we-do', :as => 'what_we_do', :to => 'home#what_we_do'

  root :to => 'home#home'
  match '/', :to => 'home#home', :as => 'home'

  # Ajax Only
  match '/pfz', :to => 'ajax#placefinder_by_zip', :as => 'placefinder_by_zip'
end
