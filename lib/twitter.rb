module TwitterClone
  CONSUMER_KEY = "eZ17eRpN1In39HuCfM5WA"
  CONSUMER_SECRET = "SfXvytpQro7PctvJhFAEbxjiY5uTT6ICqc52gzwQxMc"

  def get_consumer
    consumer = OAuth::Consumer.new( CONSUMER_KEY, CONSUMER_SECRET, 
      :site => "http://api.twitter.com",
      :request_endpoint => 'http://api.twitter.com',
      :sign_in => true )
  end

  def generate_request_token
    consumer = get_consumer
    consumer.get_request_token
  end

  def get_authorize_link
    @@request_token = generate_request_token
    @@request_token.authorize_url
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