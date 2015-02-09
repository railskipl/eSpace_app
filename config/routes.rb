Rails.application.routes.draw do

  resources :credit_cards, :only => [:new,:create,:index, :destroy]
  resources :about_us
  resources :access_ids , :except => [:show]
  resources :faqs
  get 'frequently_asked_question' => "faqs#frequently_asked_question", as: "frequently_asked_question"

  resources :order_receives, :only => [:index] do
    collection do
      get 'cancel_booking'
      get 'cancel_popup'
    end
  end

  devise_scope :user do
    get '/sign_out' => 'users/sessions#destroy'
  end

  get '/search_order_received_by_date' => "order_receives#search_order_received_by_date", as: "search_order_received_by_date"

  get 'payement_transfers/index'

  get 'ratings/update'

  get '/payments' => "order_receives#payments" , as: "payments"

  resources :admins, :only => [:show,:destroy,:index]

  resources :bank_details, :only => [:index,:new,:create, :destroy, :show]

  resources :disputes, :only => [:index, :show] do
    collection do
      get 'search'
      get 'search_user'
      get 'hold'
    end
    member do
      get 'hold_money'
      get 'refund_money_to_finder'
      get 'send_money'
      put 'send_money'
      get 'charge_money'
      get 'charge_to_poster'
      put 'refund_finder'
      put 'sent_to_poster'
      put 'charged_money'
      put 'charged_to_poster'
    end
  end
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks",sessions: 'users/sessions',registrations: 'users/registrations', passwords: 'users/passwords'}
  root :to => 'home#index'

  resources :omniauth_callbacks ,:only => [:new, :create]
   get 'auth/failure' => redirect('/')

   resources :authenticates, :only => [:create] do
      collection do
        get 'check_email'
      end
   end

   resources :users ,:except => [:create] do
    collection do
        get 'order_received'
        get 'new_user'
        post 'create_user'
    end
  end


   delete '/users/:id/delete', :to => "users#destroy" , :as => 'delete_user'
   get '/users/:id/status', :to => "users#toggled_status"
   get '/about-us', :to => "about_us#about"

   get '/mutual_friends', to: 'posts#mutual'

   match 'search_payments' => "payement_transfers#search_payments", via: [:get, :post]

   match 'search_by_date' => "bookings#search_by_date", via: [:get, :post]
   resources :contactus
   # resources :home
   match 'home/contactus',:to => "home#contactus", via: [:get, :post]
   get 'home/about_us',:to => "home#about_us"
   get '/home/all_postings', :to => "home#all_postings"
   get  'search'  => "home#searching"
   get  'searched'  => "home#search_post", :as => 'search_post'
   get 'terms',:to => "home#terms"
   get  'search'  => "posts#search"
   match 'posts/overview' => "posts#overview", via: [:get, :post]

  resources :comments, :only => [:show, :create, :index] do
    collection do
        get 'books'
    end
  end

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

  resources :bookings, :except => [:edit,:update,:destroy] do
    collection do
      post 'checkout'
      get 'cancel_booking'
      get 'cancel_popup'
      get 'rating'
      get 'drop_off'
      get 'confirm'
    end
  end

  resources :ratings, only: :update

  resources :messages, :only => [:new, :create, :index] do
    collection do
      get 'sent_messages'
      get 'refresh_part'
      get 'refresh_message'
      get 'check_message'
      get 'user_message'
      get 'compose_message'
      post 'sent_to'
    end

    member do
     get 'reply'
     get 'is_read_all'
    end
  end

  resources :payement_transfers ,:path => "payment_transfers" ,:only => [:index] do
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