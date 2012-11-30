JobsJugaad::Application.routes.draw do
  
  match "/auth/twitter/callback" => "employers#post_to_twitter"

  get "faqs" => "home#faqs"

  resources :job_seekers, :except => [:new] do 
    collection do 
      get "register" => :new
      post "register" => "sessions#register"
    end
    member do 
      get "download_resume" => :download_resume
      get "remove_photo" => :remove_photo 
      get "change_password" => "sessions#change_password"
      get "get_api_token" => :get_api_token
    end
  end
  controller 'job_seekers' do
    get "profile" => :profile
    post "upload_photo" => :upload_asset
    post "upload_resume" => :upload_asset
  end
  match "autocomplete_skill_name" => "job_seekers#autocomplete_skill_name"
  
  resources :employers, :except => [:new, :index] do
    collection do 
      get "register" => :new
      get "login" => :login
      post "register" => "sessions#register", :as => "emp_reg"
    end
    member do
      get "change_password" => "sessions#change_password"
      get "add_job" => :add_job
      get "get_api_token" => :get_api_token
      get "remove_photo" => :remove_photo
    end
  end

  controller 'employers' do
    get "eprofile" => :profile
  end

  resources :jobs do
    member do 
      get "view_applicants" => :view_applicants
      get "post_job_on_twitter" => "employers#post_to_twitter"
      get "post_tweet" => "employers#post_tweet"
      get "view_job_applicants" => "job_applications#view_applicants"
      post "apply" => :apply
    end
  end
  
  controller :jobs do
    post "search_results" => :search_results
    get "search_results" => :search_results
    # post "apply" => :apply
  end

  resources :sessions, :except => [:destroy]

  controller :sessions do
    get "logout" => :destroy
    post "login" => :login
    get "activate_user" => :activate_user

    get "update_password" => :update_password
    post "update_password" => :update_password

    get "forgot_password" => :forgot_password
    post "reset_password" => :reset_password
    get "set_new_password" => :set_new_password
    get "reset_user_password" => :reset_user_password
    post "set_new_password" => :set_new_password
    post "save_new_password" => :save_new_password
    get "set_locale" => :set_locale
  end

  resources :job_applications, :only => [:update] do 
    member do
      get "perform_action" => :perform_action
      get "call_for_interview" => :call_for_interview
    end
  end
  
  namespace :admin do
    resources :admin, :except => [:new, :destroy] do
      member do 
        # get "change_password" => "sessions#change_password"
      end
    end
    controller :admin do
      get "admin_profile" => :profile
    end
  end

  root :to => 'home#index'

end
