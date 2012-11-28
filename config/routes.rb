JobsJugaad::Application.routes.draw do
  
  match "/auth/twitter/callback" => "employers#post_to_twitter"

  get "faqs" => "home#faqs"

  resources :job_seekers, :except => [:new] do 
    # get "profile" => :profile, :on => :member
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
    end
  end

  controller 'employers' do
    get "eprofile" => :profile
    get "emp_edit" => :edit
    get "remove_photo_emp" => :remove_photo
    get "call_for_interview" => :call_for_interview
  end

  resources :jobs do
    member do 
      get "view_applicants" => :view_applicants
      get "post_job_on_twitter" => "employers#post_to_twitter"
      get "post_tweet" => "employers#post_tweet"
    end
  end
  
  controller :jobs do
    post "search_results" => :search_results
    get "search_results" => :search_results
    post "apply" => :apply
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

  resources :job_applications, :only => [:update]
  controller :job_applications do 
    get "rejected" => :rejected
    get "shortlisted" => :shortlisted
    get "view_shortlisted" => :view_shortlisted
    get "calling_for_interview" => :calling_for_interview
    get "view_called_for_interview" => :view_called_for_interview
    get "called_for_interview" => :called_for_interview
    get "view_given_offer" => :view_given_offer
    get "accepted_offer" => :accepted_offer
    get "rejected_offer" => :rejected_offer
    get "invalid_action" => :invalid_action
  end
  
  # namespace :admin do
  # end

  resources :admin, :except => [:new, :destroy] do
    member do 
      get "change_password" => "sessions#change_password"
    end
  end

  controller :admin do
    get "admin_profile" => :profile
  end
  
  root :to => 'home#index'

end
