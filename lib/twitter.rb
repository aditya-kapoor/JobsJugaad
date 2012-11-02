module TwitterClone
  CONSUMER_KEY = "eZ17eRpN1In39HuCfM5WA"
  CONSUMER_SECRET = "SfXvytpQro7PctvJhFAEbxjiY5uTT6ICqc52gzwQxMc"
  $request_token = ""
  def get_consumer
    consumer = OAuth::Consumer.new( CONSUMER_KEY, CONSUMER_SECRET, 
      :site => "http://api.twitter.com",
      :request_endpoint => 'http://api.twitter.com',
      :sign_in => true )
  end

  def generate_request_token(callback)
    consumer = get_consumer
    $request_token = consumer.get_request_token(:oauth_callback => callback)
  end

  def generate_access_token(oauth_verifier)
    $request_token.get_access_token(:oauth_verifier => oauth_verifier)
  end

  def save_token(token, secret)
    self.oauth_access_token = token
    self.oauth_access_token_secret = secret
    self.save
  end

  def check_for_existing_tokens(request_token)
    if self.oauth_access_token && self.oauth_access_token_secret
      token, secret = self.oauth_access_token, self.oauth_access_token_secret
    end
  end

  def configure_twitter(token, secret)
    Twitter.configure do |config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.oauth_token = token
      config.oauth_token_secret = secret
    end 
  end
end