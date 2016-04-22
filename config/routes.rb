Rails.application.routes.draw do
  # DONT ADD ANY ROUTE DEFINITIONS ABOVE DEVISE, IT MUST BE FIRST

  # Devise configuration (note, setting path to '' means we don't have /users/sign_up it will be /sign_up)
  # Also, changing the sign_in and edit paths to /login and /edit_account
  devise_for :users, path: '', path_names: { sign_in: 'login', edit: 'edit_account' }

  # Root URL maps to the buy controller root action which redirects to the index action
  root 'buy#root'

  # Specific pages
  get '/buy' => 'buy#index'
  get '/map' => 'map#index'
  get '/dashboard' => 'dashboard#index'
  
  # Static Pages routes
  get '/privacy' => 'static_pages#privacy'
  get '/terms' => 'static_pages#terms'

  # Sell Pages routes (done as a resources routs to get 6 of the 7 resource actions)
  resources :sell, except: [:show]


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
