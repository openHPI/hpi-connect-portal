HpiHiwiPortal::Application.routes.draw do

  prefix = HpiHiwiPortal::Application.config.relative_url_root || ''

  scope prefix do

    scope "(:locale)", locale: /en|de/ do

      root to: "home#index"

      namespace :admin do
        resource :configurable, except: [:index]
      end

      resources :job_offers do
        collection do
          get "archive"
          get "matching"
        end
        member do
          get "close"
          get "accept"
          get "decline"
          get "reopen"
          get "prolong"
          get "request_prolong"
          post "fire"
        end
      end

      resources :employers do
        collection do
          get "home"
        end 
        member do
          get "activate"
          get "deactivate"
        end
      end

      resources :applications, only: [:create, :destroy] do
        member do
          get "accept"
          get "decline"
        end
      end

      resources :alumni, only: [:new, :create, :index, :show] do
        collection do
          get 'remind_via_mail'
          post 'import' => 'alumni#create_from_csv'
          post 'mail_csv' => 'alumni#send_mail_from_csv'
        end
      end
      get 'alumni/:token/email' => 'alumni#register', as: 'alumni_email'
      post 'alumni/:token/link' => 'alumni#link', as: 'alumni_link'
      post 'alumni/:token/link_new' => 'alumni#link_new', as: 'alumni_link_new'

      post 'forgot_password' => 'users#forgot_password'

      resources :users, only: [:edit, :update] do
        patch 'update_password' => 'users#update_password', as: 'update_password'
      end

      resources :home, only: [:index, :imprint]
      get 'home/imprint'
      
      resources :sessions, only: [:create]
      get 'signin' => 'home#index', as: 'signin'
      delete 'signout' => 'sessions#destroy', as: 'signout'

      resources :studentsearch
      resources :faqs

      resources :staff, except: [:edit, :update]

      resources :students do
        member do
          patch 'activate'
          get 'activate'
          get 'request_linkedin_import'
          get 'insert_imported_data'
          post 'rate'
        end
      end

      resources :newsletter_orders, only: [:destroy, :create, :new, :show]

    end
  end
end
