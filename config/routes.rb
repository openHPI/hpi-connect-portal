HpiHiwiPortal::Application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  scope "(:locale)", locale: /en|de/ do

  get "imprint/index"
  resources :user_statuses
    root :to => "login_page#index"

    resources :job_offers do
      collection do
        get "archive"
        get "matching"
      end
      member do
        get "complete"
        get "accept"
        get "decline"
        get "reopen"
      end
    end

    resources :chairs
		get "chairs/:id/find_jobs", to: "chairs#find_jobs", as: "find_jobs_chairs"
    
    resources :users, only: [:edit, :update]

    resources :applications, only: [:create, :destroy] do
      member do
        get "accept"
        get "decline"
      end
    end

    devise_for :users, controllers: { sessions: 'sessions' }

    resources :programming_languages
    resources :languages

    resources :users
    resources :user_statuses

    resources :studentsearch
    resources :faqs

    resources :staff, except: [:new, :create]

    resources :students do
        collection do
            get 'students/new' => 'students#new'
            post 'students' => 'students#create'
            get 'matching'
            post 'update_role'
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
end
