require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  # a new user logs on to the website, and then searches for the job and then 
  # is redirected to its profile page when he has successfully applied for the job

  test "Login of the Job Seeker followed by application to a job" do
    # JobSeeker.destroy_all
    # job_seeker = job_seekers(:one)

    #visits the home page
    get "/#{I18n.locale}"
    assert_response :success
    assert_template "index"

    #logins by entering its credentials
    post_via_redirect "/login",
    :email => "testing10@testing.com", 
    :password => "123456",
    :user_type => "am9iX3NlZWtlcg=="

    assert_equal "/#{I18n.locale}/profile", path
    assert_template "profile"
    assert_select 'div#logged_in_holder' do
      assert_select 'p', 1
      assert_select 'p:nth-child(1)', "Logged in as testing10@testing.com | Log Out"
    end  

    # goes to the main index page and searches for job
    get "/#{I18n.locale}"
    assert_response :success
    assert_template "index"
    post_via_redirect "/search_results"
    assert_response :success
    assert_template "search_results"
    assert_select 'table#job-listings' do
      assert_select 'tr', 1
    end

    #Applies to the selected job
    post_via_redirect "/jobs/10/apply"
    assert_equal "/#{I18n.locale}/profile", path
    assert_template "profile"
    assert_equal "You have successfully applied to this job", flash[:notice]
  end
end