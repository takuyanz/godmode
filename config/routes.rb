Rails.application.routes.draw do
  get 'settings/index'

  root to: "events#index"
  get 'auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/welcome' => 'welcome#index'
  get '/search' => 'search#index', as: :search
  get '/search/load_more_albums' => 'search#load_more_albums'
  get '/search/load_more_users' => 'search#load_more_users'
  post '/clips/switch' => 'clips#switch'
  post '/createuser' => 'sessions#create'

  resources :users do
    collection do
      get 'load_more_albums'
    end
  end
  
  resources :settings, only: :index
  resources :albums, except: [:update, :edit, :new]
  resources :likes, only: :create do 
    collection do
      get 'check_liked'
    end
  end

  resources :messages, only: [:index, :create, :show] do
    collection do
      get 'search_user'
      get 'show_clipped'
      get 'load_more_messages'
      get 'mark_seen'
    end
  end

  resources :notifications, only: :index
  resources :events, only: :index
  resources :relationships, only: :update
  resources :comments, only: [:create, :show, :destroy]
  resources :replies, only: [:create, :show]

  #match '*path' => 'application#error404', via: :all
   


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
