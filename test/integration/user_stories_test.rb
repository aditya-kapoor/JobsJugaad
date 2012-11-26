require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  # fixtures :job_seekers
  test "Registration of the Job Seeker" do
    JobSeeker.destroy_all
    # job_seeker = job_seekers(:one) 
    get "/"
    assert_response :success
    assert_template "index"

    get "/job_seekers/register"
    assert_response :success
    assert_template "job_seekers/new"

    post_via_redirect "/job_seekers/register",
                      :user_type => "am9iX3NlZWtlcg==",
                      :job_seeker => {
                        :name => "Testing Job Seeker",
                        :gender => "1", 
                        :email => "testing@testing.com",
                        :date_of_birth => "01/01/1990",
                        :password => "123456",
                        :password_confirmation => "123456", 
                        :mobile_number => "1234567890",
                        :location => "Mumbai",
                        :experience => "5",
                        :industry => "IT",
                        :activated => false,
                        :photo_file_name => "photo.jpeg",
                        :photo_content_type => "image/jpeg",
                        :photo_file_size => "17185",
                        :photo_updated_at => "2012-11-07 21:34:43 +0530",
                        :resume_file_name => "resume.pdf",
                        :resume_content_type => "application/pdf",
                        :resume_file_size => "17185",
                        :resume_updated_at => "2012-11-07 21:34:43 +0530",
                        :skill_name => "php, ruby"
                      }
    assert_response :success
    assert_template "index"
    job_seekers = JobSeeker.all
    assert_equal 1, job_seekers.size
    assert_equal "Testing Job Seeker", job_seekers[0].name
  end

  test "Login As Job Seeker" do
    get "/"
    assert_response :success
    assert_template "index"

    post_via_redirect "/login",
    :user_type => "am9iX3NlZWtlcg==",
    :email => "testing@testing.com", 
    :password => "123456"
    assert_response :success
    assert_template "job_seekers/profile"
  end

  test "Search for jobs" do
    get "/"
    assert_response :success
    assert_template "index"

    post "/search_results"
    assert_response :success
    assert_template "jobs/search_results"
  end
end