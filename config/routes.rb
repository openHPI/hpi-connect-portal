HpiHiwiPortal::Application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  scope "(:locale)", locale: /en|de/ do

	get "home/index"
    get "home/imprint"

    root to: "sessions#new"

    get "imprint", to: "imprint#index"

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

    get "employers/external", to: "employers#index_external", as: "external_employers"

    resources :employers

    resources :applications, only: [:create, :destroy] do
      member do
        get "accept"
        get "decline"
      end
    end

    resources :users, only: [:edit, :update]

    resources :sessions, only: [:new, :create, :destroy]
    get '/signin' => 'sessions#new', as: 'signin'
    delete '/signout' => 'sessions#destroy', as: 'signout'

    resources :studentsearch
    resources :faqs

    resources :staff, except: [:edit, :update]

    resources :students do
      collection do
        get 'students/new' => 'students#new'
        post 'students' => 'students#create'
        get 'matching'
      end
    end
  end
end
