module EmployersControllerHelperFunctions
  def update_tweet_on_timeline(description)
    Twitter.update(description)
  end
end