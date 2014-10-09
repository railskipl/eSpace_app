Rails.application.routes.draw do

   # as :user do
       # get 'users/:id/edit' => 'users#edit', :as => 'edit_user'    
     
   #  end

  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks",sessions: 'users/sessions',registrations: 'users/registrations'}

  root :to => 'home#index'

<<<<<<< HEAD
   resources :omniauth_callbacks 
   resources :authenticates
   resources :users, :only => [:index,:edit,:update]
   get 'users/:id/delete', :to => "users#destroy" , :as => 'delete_user'    
   get '/users/:id/status', :to => "users#toggled_status"
 
   get "users/check_email", :controller => "users", :action => "check_email"
=======
  resources :authenticates

  resources :posts
  
>>>>>>> f769ae9c6b649f1521eefc4362f1d1d8f57b54f8
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
