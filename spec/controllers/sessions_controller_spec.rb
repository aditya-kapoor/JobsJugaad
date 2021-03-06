require 'spec_helper'

describe SessionsController do
  include ValidAttributeCollection

  before do 
    @job_seeker = JobSeeker.new(valid_job_seeker_attributes)
    @job_seeker.email = "testing@testing.com"
    @job_seeker.save
    @employer = Employer.new(valid_employer_attributes)
    @employer.email = "employer@testing.com"
    @employer.save
    @admin = Admin.create(valid_admin_attributes)
  end

  #--complete
  describe "Action Login" do
    context "When User either (job_seeker|employer|admin) is already logged in" do
      def do_login(user)
        get :login, :user_type => Base64.encode64("#{user}")  
      end 
      before do
        session[:id] = 1
      end
      it "Must redirect to the root url" do
        ["employer", "job_seeker", "admin"].each do |user|
          do_login(user)
          response.should redirect_to(root_path)
        end
      end
    end
    context "When User either (job_seeker|employer|admin) is trying to log into the system" do
      def do_login(user)
        get :login, :user_type => Base64.encode64("#{user}")      
      end 
      before do
        session[:id] = nil
      end
      it "Must not redirect to their respective profile paths" do
        ["employer", "job_seeker", "admin"].each do |user|
          do_login(user)
          flash[:error].should eq("Invalid Email and Password Combination")
          response.should redirect_to(root_path)
        end
      end
    end

    context "When Job Seeker is trying to log with correct credentials" do
      def do_login
        get :login, :user_type => Base64.encode64("job_seeker"), 
            :email => "testing@testing.com", :password => "123456"
      end
      before do
        session[:id] = nil
      end
      it "Job Seeker Account is not activated" do
        do_login
        flash[:error].should eq("You have not activated your account yet!!")
        response.should redirect_to(root_path)
      end
    end
    context "Job Seeker should redirect to its profile page" do
      def do_login
        get :login, :user_type => Base64.encode64("job_seeker"), 
            :email => "testing@testing.com", :password => "123456"
      end
      before do
        session[:id] = nil
      end
      it "Should be redirected to the profile page" do
        @job_seeker.activated = true
        @job_seeker.save
        do_login
        response.should redirect_to(profile_path)
      end
    end

    context "When Employer is trying to log with correct credentials" do
      def do_login
        get :login, :user_type => Base64.encode64("employer"), 
            :email => "employer@testing.com", :password => "123456"
      end
      before do
        session[:id] = nil
      end
      it "Job Seeker Account is not activated" do
        do_login
        flash[:error].should eq("You have not activated your account yet!!")
        response.should redirect_to(root_path)
      end
    end
    context "Employer should redirect to its profile page" do
      def do_login
        get :login, :user_type => Base64.encode64("employer"), 
            :email => "employer@testing.com", :password => "123456"
      end
      before do
        session[:id] = nil
      end
      it "Should be redirected to the profile page" do
        @employer.activated = true
        @employer.save
        do_login
        response.should redirect_to(eprofile_path)
      end
    end

    context "When Admin is trying to log with correct credentials" do
      def do_login
        get :login, :user_type => Base64.encode64("admin"), 
            :email => "testing@testing.com", :password => "123456"
      end
      before do
        session[:id] = nil
      end
      it "Should be redirected to the profile page" do
        do_login
        response.should redirect_to(admin_admin_profile_path)
      end
    end
  end

  # --complete
  describe "Action Register" do 
    #--complete
    context "When the user is job seeker" do
      def do_register
        post :register, :user_type => Base64.encode64("job_seeker"), :job_seeker => { }
      end
      before do 
        session[:id] = nil
      end
      it "should not be able to register job seeker successfully" do
        do_register
        response.should render_template("job_seekers/new")
        response.should be_success
      end
    end
    #-complete
    context "When the user is job seeker" do
      def do_register
        post :register, :user_type => Base64.encode64("job_seeker"),
        :job_seeker => valid_job_seeker_attributes
      end
      before do 
        session[:id] = nil
      end
      it "should be able to register job seeker successfully" do
        controller.should_receive(:save_credentials).with("JobSeeker", valid_job_seeker_attributes.with_indifferent_access, "job_seekers/new").and_return(true)
        controller.stub!(:render)
        do_register
        # response.should be_success
      end
    end
    #--complete
    context "When the user is employer" do
      def do_register
        post :register, :user_type => Base64.encode64("employer"), :employer => { }
      end
      before do 
        session[:id] = nil
      end
      it "should not be able to register employer successfully" do
        do_register
        response.should render_template("employers/new")
        response.should be_success
      end
    end
    #--done (Missing Template Error) --same as above
    # simply use controller.stub!(:render), becoz RSPec will call it at some point of execution
    context "When the user is employer" do
      def do_register
        post :register, :user_type => Base64.encode64("employer"),
            :employer => valid_employer_attributes
      end
      before do 
        session[:id] = nil
      end
      it "should be able to register employer successfully" do
        controller.should_receive(:save_credentials).with("Employer", valid_employer_attributes.with_indifferent_access, "employers/new").and_return(true)
        controller.stub!(:render)
        do_register
      end
    end
  end

  # --complete
  describe "Action Change Password" do 
    context "For Job Seeker" do
      def do_change_password(id)
        get :change_password, :id => id
      end
      before do 
        session[:id] = @job_seeker.id
        session[:user_type] = "job_seeker"
      end
      it "should display the change password template" do
        do_change_password(@job_seeker.id)
        response.should be_success
        response.should render_template("sessions/change_password")
      end
      it "Filter Fails" do
        do_change_password(100)
        flash[:error].should eq("You are not authorised to do this")
        response.should redirect_to(root_path)
      end
    end
    context "For Employer" do
      def do_change_password(id)
        get :change_password, :id => id
      end
      before do 
        session[:id] = @employer.id
        session[:user_type] = "employer"
      end
      it "should display the change password template" do
        do_change_password(@employer.id)
        response.should be_success
        response.should render_template("sessions/change_password")
      end
      it "Filter Fails" do
        do_change_password(100)
        flash[:error].should eq("You are not authorised to do this")
        response.should redirect_to(root_path)
      end
    end
    context "For Admin" do
      def do_change_password(id)
        get :change_password, :id => id
      end
      before do 
        session[:id] = @admin.id
        session[:user_type] = "admin"
      end
      it "should display the change password template" do
        do_change_password(@admin.id)
        response.should be_success
        response.should render_template("sessions/change_password")
      end
      it "Filter Fails" do
        do_change_password(100)
        flash[:error].should eq("You are not authorised to do this")
        response.should redirect_to(root_path)
      end
    end
  end

  # --complete
  describe "Action Update Password" do
    #--complete
    context "When Job Seeker is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "JobSeeker", :old_password => "123456", 
          :job_seeker => { :password => "qwerty", :password_confirmation => "qwerty" }
      end 
      before do
        session[:id] = @job_seeker.id
        session[:user_type] = "job_seeker"
      end
      it "should successfully change the password" do
        do_update_password
        flash[:notice].should eq("Password has been changed successfully.")
        response.should redirect_to(profile_path)
      end
    end
    #--complete
    context "When Job Seeker is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "JobSeeker", :old_password => "1234", 
          :job_seeker => { :password => "qwerty", :password_confirmation => "qwerty" }
      end 
      before do
        session[:id] = @job_seeker.id
        session[:user_type] = "job_seeker"
      end
      it "should not change the password" do
        request.stub('referrer').and_return(root_path)
        do_update_password
        flash[:error].should eq("Invalid Password")
        response.should redirect_to(request.referrer)
      end
    end

    #--complete
    context "When Job Seeker is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "JobSeeker", :old_password => "123456", 
          :job_seeker => { :password => "qwerty", :password_confirmation => "" }
      end 
      before do
        session[:id] = @job_seeker.id
        session[:user_type] = "job_seeker"
      end
      it "should not change the password due to some validation issues in new password" do
        do_update_password
        flash[:error].should eq("There Were Some Errors")
        response.should be_success
        response.should render_template("sessions/change_password")
      end
    end

    #--complete
    context "When Employer is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "Employer", :old_password => "123456", 
          :employer => { :password => "qwerty", :password_confirmation => "qwerty" }
      end 
      before do
        session[:id] = @employer.id
        session[:user_type] = "employer"
      end
      it "should successfully change the password" do
        do_update_password
        flash[:notice].should eq("Password has been changed successfully.")
        response.should redirect_to(eprofile_path)
      end
    end  
    #--complete
    context "When Employer is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "Employer", :old_password => "123456", 
          :employer => { :password => "qwerty", :password_confirmation => "qwerty" }
      end 
      before do
        session[:id] = @employer.id
        session[:user_type] = "employer"
      end
      it "should successfully change the password" do
        do_update_password
        flash[:notice].should eq("Password has been changed successfully.")
        response.should redirect_to(eprofile_path)
      end
    end
    #--complete
    context "When Employer is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "Employer", :old_password => "1234", 
          :employer => { :password => "qwerty", :password_confirmation => "qwerty" }
      end 
      before do
        session[:id] = @employer.id
        session[:user_type] = "employer"
      end
      it "should not change the password" do
        request.stub('referrer').and_return(root_path)
        do_update_password
        flash[:error].should eq("Invalid Password")
        response.should redirect_to(request.referrer)
      end
    end
    #--complete
    context "When Employer is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "Employer", :old_password => "123456", 
          :employer => { :password => "qwerty", :password_confirmation => "" }
      end 
      before do
        session[:id] = @employer.id
        session[:user_type] = "employer"
      end
      it "should not change the password due to some validation issues in new password" do
        request.stub('referrer').and_return(root_path)
        do_update_password
        flash[:error].should eq("There Were Some Errors")
        response.should be_success
        response.should render_template("sessions/change_password")
      end
    end

    #--complete
    # context "When Admin is logged in the system" do
    #   def do_update_password
    #     post :update_password, :user_type => "Admin", :old_password => "123456", 
    #       :admin => { :password => "qwerty", :password_confirmation => "qwerty" }
    #   end 
    #   before do
    #     session[:id] = @admin.id
    #     session[:user_type] = "admin"
    #   end
    #   # it "should successfully change the password" do
    #   #   do_update_password
    #   #   flash[:notice].should eq("Password has been changed successfully.")
    #   #   response.should redirect_to(admin_admin_profile_path)
    #   # end
    # end
    #--complete
    context "When Admin is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "Admin", :old_password => "1234", 
          :admin => { :password => "qwerty", :password_confirmation => "qwerty" }
      end 
      before do
        session[:id] = @admin.id
        session[:user_type] = "admin"
      end
      it "should not change the password" do
        request.stub('referrer').and_return(root_path)
        do_update_password
        flash[:error].should eq("Invalid Password")
        response.should redirect_to(request.referrer)
      end
    end
    #--complete
    context "When Admin is logged in the system" do
      def do_update_password
        post :update_password, :user_type => "Admin", :old_password => "123456", 
          :admin => { :password => "qwerty", :password_confirmation => "" }
      end 
      before do
        session[:id] = @admin.id
        session[:user_type] = "admin"
      end
      it "should not change the password due to some validation issues in new password" do
        request.stub('referrer').and_return(root_path)
        do_update_password
        flash[:error].should eq("There Were Some Errors")
        response.should be_success
        response.should render_template("sessions/change_password")
      end
    end
  end

  # --complete
  describe "Action Logout" do 
    def do_logout
      get :destroy
    end
    before do
      session[:id] = 1
    end
    it "should reset the session" do
      do_logout
      flash[:notice].should eq("You have been logged out from all the pages of website")
      response.should redirect_to(root_path)
    end
  end

  # --complete
  describe "Action Forgot Password" do
    def do_forgot_password(user)
      get :forgot_password, :user => "#{user}"
    end
    it "should take the user to the forgot password page" do
      ["employer", "job_seeker"].each do |user|
        do_forgot_password("employer")
        response.should be_success
        response.should render_template("sessions/forgot_password")
      end
    end
  end

  # --complete
  describe "Action Reset Password" do
    context "For Job Seeker" do 
      def do_reset_password(user, email)
        post :reset_password, :user => "#{user}", :email => "#{email}"
      end
      before do 
        session[:id] = nil
      end
      it "should send the email from the forgot password" do
        do_reset_password("JobSeeker", "testing@testing.com")
        flash[:notice].should eq("Reset Password instructions has been sent to your mail account")
        response.should redirect_to(root_path)
      end
      it "should not send the mail for forgot password" do
        do_reset_password("JobSeeker", "abc@gmail.com")
        flash[:error].should eq("There Was An Error With your email")
        response.should redirect_to(root_path)
      end
    end
    context "For Employer" do 
      def do_reset_password(user, email)
        post :reset_password, :user => "#{user}", :email => "#{email}"
      end
      before do 
        session[:id] = nil
        @employer = Employer.create(valid_employer_attributes)
      end
      it "should send the email from the forgot password" do
        do_reset_password("Employer", "employer@testing.com")
        flash[:notice].should eq("Reset Password instructions has been sent to your mail account")
        response.should redirect_to(root_path)
      end
      it "should not send the mail for forgot password" do
        do_reset_password("Employer", "abc@gmail.com")
        flash[:error].should eq("There Was An Error With your email")
        response.should redirect_to(root_path)
      end
    end
  end

  #--complete
  describe "Action Reset User Password" do
    def do_reset_user_password(type, email, token)
      get :reset_user_password, :type => "#{type}", :email => "#{email}", :auth_token => "#{token}"
    end
    before do
      auth_token = BCrypt::Password.create("Tutu")
      @job_seeker.password_reset_token = auth_token
      @job_seeker.save
    end
    it "should redirect to the set_new_password page" do
      do_reset_user_password(@job_seeker.class.to_s, @job_seeker.email, @job_seeker.password_reset_token)
      response.should redirect_to (set_new_password_path)
    end
    it "should not redirect to the set_new_password page" do
      do_reset_user_password(@job_seeker.class.to_s, "aditya@gmail.com", @job_seeker.password_reset_token)
      flash[:notice].should eq("Your link is incorrect")
      response.should redirect_to(root_path)
    end
  end

  #--complete
  describe "Action Set New Password" do 
    def do_set_new_password 
      get :set_new_password
    end
    before do 
      session[:id] = @job_seeker.id
      session[:user_type] = "job_seeker"
    end
    it "should render the set new password page with session setted" do
      do_set_new_password
      response.should be_success
      response.should render_template("sessions/set_new_password")
    end
  end

  #--complete
  describe "Action Save New Password" do
    def do_save_new_password(password, password_confirmation)
      post :save_new_password, :job_seeker => { :password => "#{password}", 
          :password_confirmation => "#{password_confirmation}"}
    end
    before do
      session[:id] = @job_seeker.id
      session[:user_type] = "job_seeker"
    end
    it "should successfully save the password" do 
      do_save_new_password("qwerty", "qwerty")
      flash[:notice].should eq("Your Password has been reset successfully..Login now!!")
      response.should redirect_to(root_path)
    end
    it "should not save the password" do
      do_save_new_password("qwerty", "123456")
      response.should be_success
      response.should render_template("sessions/set_new_password")
    end
  end

  #--complete
  describe "Action Activate User" do
    context "When Job Seeker" do 
      def do_activate_user(token, email)
        get :activate_user, :type => "JobSeeker", :auth_token => "#{token}", :email => "#{email}"
      end
      before do

      end
      it "should activate the user" do
        do_activate_user(@job_seeker.auth_token, @job_seeker.email)
        flash[:notice].should eq("Your Accrount Has been activated successfully..")
        response.should redirect_to(root_path)
      end
      it "should not activate the user" do
        do_activate_user(@job_seeker.auth_token, "aditya@gmail.com")
        flash[:notice].should eq("There Was A Problem With Your Link")
        response.should redirect_to(root_path)
      end
    end
    context "When Employer" do 
      def do_activate_user(token, email)
        get :activate_user, :type => "Employer", :auth_token => "#{token}", :email => "#{email}"
      end
      before do 

      end
      it "should activate the user" do
        do_activate_user(@employer.auth_token, @employer.email)
        flash[:notice].should eq("Your Accrount Has been activated successfully..")
        response.should redirect_to(root_path)
      end
      it "should not activate the user" do
        do_activate_user(@employer.auth_token, "aditya@gmail.com")
        flash[:notice].should eq("There Was A Problem With Your Link")
        response.should redirect_to(root_path)
      end
    end
  end

end