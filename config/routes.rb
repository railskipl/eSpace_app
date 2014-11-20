Rails.application.routes.draw do

  get 'payement_transfers/index'

  get 'ratings/update'

  resources :pages
  
  resources :admins
  
  resources :bank_details

  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks",sessions: 'users/sessions',registrations: 'users/registrations'}

  root :to => 'home#index'

   resources :omniauth_callbacks 
   get 'auth/failure' => redirect('/')

   resources :authenticates do
      collection do
        get 'check_email'
      end
   end

   resources :users do 
    collection do
        get 'order_received'
        get 'new_user'
        post 'create_user'
    end
  end


   delete '/users/:id/delete', :to => "users#destroy" , :as => 'delete_user'    
   get '/users/:id/status', :to => "users#toggled_status"

   get '/mutual_friends', to: 'posts#mutual'

   match 'search_by_date' => "bookings#search_by_date", via: [:get, :post]
   resources :contactus
   # resources :home
   get 'home/contactus',:to => "home#contactus"
   get '/home/all_postings', :to => "home#all_postings"
   get  'search'  => "home#searching"
   get  'searched'  => "home#search_post", :as => 'search_post'
   get 'terms',:to => "home#terms"
   get  'search'  => "posts#search"
   match 'posts/overview' => "posts#overview", via: [:get, :post]

  resources :comments
  resources :posts do
    resources :comments, :only => [:create, :show]
    member do
        get 'toggle'
        get 'toggled_feature'
    end
    collection do
        get 'archive'
        
    end
  end

  resources :bookings do
    collection do
      post :checkout
      get 'cancel_booking'
    end
  end

  
  resources :ratings, only: :update

  resources :messages do
    collection do
      get :trash_messages
      get :sent_messages
      put :move_all_to_trash_recipient
      put :delete_all_by_sender
      get :refresh_part
      get :refresh_message
      get :user_message
      get :compose_message
      post :sent_to
    end
    
    member do
     post :trash
     post :destroy_recipient
     post :destroy_sender
     get :reply
     get :is_read_all
    end
  end

  resources :payement_transfers do 
    collection do
      get 'transfer_money'
      get 'check_status'
    end
  end  
 

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end


end
