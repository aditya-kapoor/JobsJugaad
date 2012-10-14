JobsJugaad::Application.routes.draw do

  match "/auth/twitter/callback" => "employers#post_to_twitter"

  resources :job_seekers, :controller => "job_seekers", :except => [:new]
  controller 'job_seekers' do
    get "profile" => :profile
    get "register" => :new
    post "upload_photo" => :upload_asset
    post "upload_resume" => :upload_asset
  end
  match "autocomplete_skill_name" => "job_seekers#autocomplete_skill_name"
  
  resources :job_seekers do
    member do 
      get "download_resume" => :download_resume
      get "remove_photo" => :remove_photo 
    end
  end

  resources :employers, :controller => "employers", :except => [:new]
  controller 'employers' do
    get "elogin" => :login
    get "eregister" => :new
    get "eprofile" => :profile
    # get "add_job" => :add_job
    get "emp_edit" => :edit
    get "remove_photo_emp" => :remove_photo
    get "call_for_interview" => :call_for_interview
    # get "post_job_on_twitter" => :post_job_on_twitter
  end

  resources :jobs do
    member do 
      get "view_applicants" => :view_applicants
      get "post_job_on_twitter" => "employers#post_to_twitter"
      post "post_tweet" => "employers#post_tweet"
    end
  end
  
  controller :jobs do
    post "search_results" => :search_results
    get "search_results" => :search_results
    post "apply" => :apply
  end

  resources :job_seekers do
    member do 
      get "change_password" => "sessions#change_password"
    end
  end

  resources :employers do
    member do
      get "change_password" => "sessions#change_password"
      get "add_job" => :add_job
    end
  end

  resources :sessions, :except => [:destroy]

  controller :sessions do
    get "logout" => :destroy
    post "login" => :login
    post "eregister" => :register
    post "register" => :register
    get "activate_user" => :activate_user
    
    get "update_password" => :update_password
    post "update_password" => :update_password

    get "forgot_password" => :forgot_password
    post "reset_password" => :reset_password
    get "set_new_password" => :set_new_password
    get "reset_user_password" => :reset_user_password
    post "set_new_password" => :set_new_password
    post "save_new_password" => :save_new_password
  end

  resources :job_applications, :only => [:update]
  
  resources :admin, :except => [:new]
  
  controller :admin do
    # get "admin_login" => :login 
    # post "admin_login" => :login
    get "admin_profile" => :profile
    # get "change_admin_password" => :change_password
  end
  resources :admin do
    member do 
      get "change_password" => "sessions#change_password"
    end
  end

  root :to => 'home#index'
end
