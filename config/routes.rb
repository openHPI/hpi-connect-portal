HpiHiwiPortal::Application.routes.draw do
  get "imprint/index"
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  scope "(:locale)", locale: /en|de/ do

  resources :user_statuses
  root :to => "job_offers#index"

  resources :job_offers do
    collection do
      get "archive"
    end
    member do
      get "complete"
      get "accept"
      get "decline"
      get "reopen"
      put "prolong"
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
  end
end
