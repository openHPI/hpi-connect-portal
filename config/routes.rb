HpiHiwiPortal::Application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

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
        get "complete"
        get "accept"
        get "decline"
        get "reopen"
        put "prolong"
        post "fire"
      end
    end

    resources :employers do 
      member do
        get "activate"
      end
    end

    resources :applications, only: [:create, :destroy] do
      member do
        get "accept"
        get "decline"
      end
    end

    resources :users, only: [:edit, :update] do
      patch '/update_password' => 'users#update_password', as: 'update_password'
    end

    resources :home, only: [:index, :create, :destroy, :imprint]
    get 'home/imprint'
    get '/signin' => 'home#index', as: 'signin'
    delete '/signout' => 'home#destroy', as: 'signout'

    resources :studentsearch
    resources :faqs

    resources :staff, except: [:edit, :update]

    resources :students do
      collection do
        get 'students/new' => 'students#new'
        post 'students' => 'students#create'
      end
      member do
        patch 'activate'
        get 'activate'
        get 'request_linkedin_import'
        get 'insert_imported_data'
      end
    end
  end
end
