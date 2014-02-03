HpiHiwiPortal::Application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  scope "(:locale)", locale: /en|de/ do
    get "imprint/index"

  get "imprint/index"

  namespace :admin do
    resource :configurable, except: [:index]
  end
  
  devise_scope :user do 
    root :to => 'sessions#new'
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
    end
  end

  get "userlist" => "users#userlist"
  get "employers/external", to: "employers#index_external", as: "external_employers"

  resources :employers do
    collection do 
        post 'update_staff'
    end
  end

  #resources :users, only: [:edit, :update]

  resources :applications, only: [:create, :destroy] do
    member do
      get "accept"
      get "decline"
    end
  end

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :users, only: [:show, :edit, :update]

  resources :studentsearch
  resources :faqs

  resources :staff, except: [:new, :create] do
      collection do
          post 'update_role'
          post 'set_role_to_student'
      end
  end

  resources :students do
    collection do
      get 'students/new' => 'students#new'
      post 'students' => 'students#create'
      get 'matching'
      post 'update_role'
    end
  end
  end
end
