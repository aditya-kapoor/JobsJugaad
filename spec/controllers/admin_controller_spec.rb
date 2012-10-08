require 'spec_helper'

describe AdminController do
  before(:each) do
    @admin = double(Admin, :id => 1)
  end

  describe "index" do 

    def do_index
    end
    before do 
      @admin = mock Admin
    end
    it "should display a login form" do
      do_index
      response.should be_success
    end
  end
end