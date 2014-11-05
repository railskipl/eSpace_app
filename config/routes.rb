Rails.application.routes.draw do

  get 'ratings/update'

  resources :pages

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
        get 'new_user'
        post 'create_user'
    end
end
   get 'users/:id/delete', :to => "users#destroy" , :as => 'delete_user'    
   get '/users/:id/status', :to => "users#toggled_status"
   # get "/users/add_adminuser",:to =>"users#add_adminuser"
   
   resources :contactus
   # resources :home
   get 'home/contactus',:to => "home#contactus"
   get '/home/all_postings', :to => "home#all_postings"
   get  'search'  => "home#searching"
   get 'terms',:to => "home#terms"
   get  'search'  => "posts#search"
   match 'all_posts' => "posts#all_posts", via: [:get, :post]

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
    end
  end


resources :ratings, only: :update

  resources :messages do
    collection do
      get :trash_messages
      get :sent_messages
      put :move_all_to_trash_recipient
      put :delete_all_by_sender
    end
    
    member do
     post :trash
     post :destroy_recipient
     post :destroy_sender
     get :reply
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
