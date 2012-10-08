require 'spec_helper'

describe JobSeekersController do
  before(:each) do
    JobSeeker.stub!(:new).and_return(@job_seeker = mock_model(JobSeeker, :save => true))
  end
  
end