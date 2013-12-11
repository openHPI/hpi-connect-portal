HpiHiwiPortal::Application.routes.draw do
  scope "(:locale)", locale: /en|de/ do

    root :to => "job_offers#index"

    resources :job_offers do    
      collection do
        get "sort"
        get "search"
        get "filter"
        get "archive"
        get "find"
		get "find_archived_jobs"
      end
      member do
        get "complete"
        get "accept"
        get "decline"
      end
    end

    resources :chairs
		get "chairs/:id/find_jobs", to: "chairs#find_jobs", as: "find_jobs_chairs"
    
    resources :users, only: [:edit, :update]

    resources :applications, only: [:create] do
      member do
        get "accept"
        get "decline"
      end
    end

    devise_for :users, controllers: { sessions: 'sessions' }

    resources :students do
      collection do
        get "matching"
      end
    end
    
    resources :programming_languages
    resources :languages
    resources :student_statuses
    resources :studentsearch
    resources :faqs
  end
end
