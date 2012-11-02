module EmployersControllerHelperFunctions

  def update_tweet_on_timeline(description)
    Twitter.update(description)
    flash[:notice] = "Successfully Tweeted Job Posting"
    redirect_to eprofile_path
  end
end