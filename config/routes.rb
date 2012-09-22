JobsJugaad::Application.routes.draw do

  resources :job_seekers, :controller => "job_seekers", :except => [:new]
  controller 'job_seekers' do
    get "profile" => :profile
    get "register" => :new
    # get "forgot_password" => :forgot_password
    # get "change_password" => :change_password
    # post "update_password" => :update_password
    get "remove_photo" => :remove_photo
  end
  resources :employers, :controller => "employers", :except => [:new]
  controller 'employers' do
    get "elogin" => :login
    get "eregister" => :new
    get "eprofile" => :profile
    get "add_job" => :add_job
    # get "emp_edit" => :edit
    get "remove_photo_emp" => :remove_photo
  end
  resources :jobs
  controller :jobs do
    get "view_applicants" => :view_applicants
    # post "search" => :search
    post "search_results" => :search_results
    get "search_results" => :search_results
    post "apply" => :apply
  end
  resources :sessions, :except => [:destroy]
  controller :sessions do
    get "logout" => :destroy
    post "login" => :login
    post "eregister" => :register
    post "register" => :register
    get "change_password" => :change_password
    post "update_password" => :update_password
    get "forgot_password" => :forgot_password
    post "reset_password" => :reset_password
    get "set_new_password" => :set_new_password
    get "reset_user_password" => :reset_user_password
    get "activate_user" => :activate_user
    post "set_new_password" => :set_new_password
    post "save_new_password" => :save_new_password
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
