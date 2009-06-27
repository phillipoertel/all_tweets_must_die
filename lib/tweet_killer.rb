class TweetKiller
  
  def initialize(default_lifetime, password)
    @default_lifetime = default_lifetime
    @password = password
  end
  
  def handle_tweet(tweet)
    tweet.kill!(@password) unless tweet.should_live?(@default_lifetime)
  end
end