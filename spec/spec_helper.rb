require 'simplecov'
SimpleCov.start 'rails'
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

module ValidAttributeCollection
  def valid_job_seeker_attributes
    { :name => "Testing Job Seeker",
      :gender => 1, 
      :date_of_birth => "01/01/1990", 
      :password => "123456",
      :password_confirmation => "123456", 
      :mobile_number => "1234567890",
      :location => "Mumbai",
      :experience => 5,
      :industry => "IT",
      :activated => false,
      :photo_file_name => "photo.jpeg",
      :photo_content_type => "image/jpeg",
      :photo_file_size => 17185,
      :photo_updated_at => Time.now,
      :resume_file_name => "resume.pdf",
      :resume_content_type => "application/pdf",
      :resume_file_size => 17185,
      :resume_updated_at => Time.now,
      :skill_name => "php, ruby"
    }
  end
  def valid_employer_attributes
    {
    :name => "Testing Employer", 
    :website => "http://testing.com",
    :description => "This is the test description for the testing employer",
    :password => "123456",
    :password_confirmation => "123456",
    :activated => false,
    :photo_file_name => "photo.jpeg",
    :photo_content_type => "image/jpeg",
    :photo_file_size => 17185,
    :photo_updated_at => Time.now
    }
  end
  def valid_job_attributes 
    {
    :title => "Testing Job", 
    :description => "This is the description of the testing jobs which is specifically used for testing in the RSpec",
    :location => "Delhi",
    :salary_min => 15000,
    :salary_max => 25000,
    :salary_type => "pm",
    :skill_name => "php, java"
    }
  end
  def valid_admin_attributes
    { :name => "Testing Job Seeker", 
      :email => "testing@testing.com",
      :password => "123456",
      :password_confirmation => "123456"
    }
  end
  def valid_job_application_attributes
    { 
      :job_seeker_id => 1,
      :job_id => 1,
      :interview_on => Date.today,
      :remarks => "This column is for place and time of interview"
    }
  end
  def valid_skill_attributes
    { :name => "testing skill"
    }
  end
end

class Hash

  ##
  # Filter keys out of a Hash.
  #
  #   { :a => 1, :b => 2, :c => 3 }.except(:a)
  #   => { :b => 2, :c => 3 }

  def except(*keys)
    self.reject { |k,v| keys.include?(k || k.to_sym) }
  end

  ##
  # Override some keys.
  #
  #   { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
  #   => { :a => 4, :b => 2, :c => 3 }
  
  def with(overrides = {})
    self.merge overrides
  end

  ##
  # Returns a Hash with only the pairs identified by +keys+.
  #
  #   { :a => 1, :b => 2, :c => 3 }.only(:a)
  #   => { :a => 1 }
  
  def only(*keys)
    self.reject { |k,v| !keys.include?(k || k.to_sym) }
  end

end