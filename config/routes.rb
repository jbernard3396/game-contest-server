GameContestServer::Application.routes.draw do
#  get "matches/show"
#  get "matches/index"
  get "visual_tests/colorscheme", as: :colorscheme
  root 'users#home'

  get '/help/', to: 'help#index'
  get '/help/:category/(:page)', to: 'help#show'
  get '/match_logs/:id/std_out', to: 'match_log_infos#std_out'
  get '/match_logs/:id/std_err', to: 'match_log_infos#std_err'

  resources :users
  
  resources :referees do
      member do
          get 'assets/:asset', to: 'referees#show', :constraints => { :asset => /.*/ }, as: 'assets'
      end
  end

  resources :contests, shallow: true do
    resources :matches, except: [:edit, :update]
    resources :players
    resources :tournaments, shallow: true do
      resources :players
      resources :matches, only: [:index] do
	      resources :rounds, only: [:show]
      end
    end
  end



  resources :sessions, only: [:new, :create, :destroy]

  get 'signup', to: 'users#new', as: :signup
  get 'login', to: 'sessions#new', as: :login
  delete 'logout', to: 'sessions#destroy', as: :logout


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
