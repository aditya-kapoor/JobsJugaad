Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'eZ17eRpN1In39HuCfM5WA', 'SfXvytpQro7PctvJhFAEbxjiY5uTT6ICqc52gzwQxMc'
end

Twitter.configure do |config|
  config.consumer_key       = "eZ17eRpN1In39HuCfM5WA"
  config.consumer_secret    = "SfXvytpQro7PctvJhFAEbxjiY5uTT6ICqc52gzwQxMc"
  config.oauth_token        = "324448615-XM1nfrHahjwBkkJsj2OHgzfZ2VnQwjxfEv0q9eFN"
  config.oauth_token_secret = "edwfjpI0D9MEVj3lfk8xmYmW0yMwMNQ9NNNKbCC5BQk"
end
