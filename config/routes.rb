Rails.application.routes.draw do
  root 'pages#home'

  # login routes
  get 'login'                 => 'sessions#new'
  post 'login'                => 'sessions#create'
  delete '/logout'            => 'sessions#destroy'

  # User Dashboard
  get 'dashboard'             => 'pages#dashboard'

  # Create connectors routes
  get 'connectors/new'        => 'connectors#new'
  post 'connectors'           => 'connectors#create'
  get 'connectors/index'      => 'connectors#index'
  get 'connectors/list'       => 'connectors#list_items'
  get 'connector/:id/edit'    => 'connectors#edit'
  get 'connector/:id/update'  => 'connectors#update'

  # Ftp Connectors routes
  resources :ftp_connectors
  # get 'ftp_connectors/new'        => 'ftp_connectors#new'
  # post 'ftp_connectors/'          => 'ftp_connectors#create'
  # get 'ftp_connectors/index'      => 'ftp_connectors#index'
  # get 'ftp_connector/:id/edit'    => 'ftp_connectors#edit'
  # get 'ftp_connector/:id/update'  => 'ftp_connectors#update'
  # get 'ftp_connector/:id', to: 'ftp_connector#show', as: :ftp_connector
  # patch 'ftp_connector/:id', to: 'ftp_connector#update', as: :ftp_connector

  # Backups routes
  get '/backups/new'          =>  'backups#new'
  post '/backups/'            =>  'backups#create'
  get '/backups/index'        =>  'backups#index'

  resources :users
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
