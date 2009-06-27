require File.join(File.dirname(__FILE__), '../lib/argument_validator')

module AllTweetsMustDie
  class TweetKiller
    
    include ArgumentValidator
  
    attr_reader :default_lifetime, :username, :password

    HASHTAG_PATTERN = /#keep((\d+)h)?$/
    
    # a TweetKiller can kill many tweets, i.e. it is initialized once and processes a list of tweets with handle_tweet
    def initialize(options = {})
      validate_args!([:default_lifetime, :username, :password], options)
      @default_lifetime = options[:default_lifetime] || 12 # maximum allowed age in hours
      @username = options[:username]
      @password = options[:password]
    end
    
    # the external interface
    def handle_tweet!(tweet)
      should_live = tweet_should_live?(tweet, @default_lifetime)
      tweet.kill!(@password) unless should_live
      puts "tweet #{tweet.text[0, 20]}... should live? #{should_live}" if (ENV['VERBOSE'])
    end
      
    def tweet_should_live?(tweet, default_lifetime)
      @tweet = tweet
      hashtag = tweet.text.match(HASHTAG_PATTERN)
      hashtag ? handle_with_hashtag(hashtag) : handle_without_hashtag(default_lifetime)
    end
    
      private
      
        # handles hashtags like "#keep" and "#keep24h"
        def handle_with_hashtag(match)
          return true if match[0] == "#keep"
          maximum_age = (match[2].to_i * 60 * 60)
          @tweet.age <= maximum_age
        end
    
        # handles tweets without hashtag
        def handle_without_hashtag(default_lifetime)
          maximum_age = (default_lifetime * 60 * 60)
          @tweet.age <= maximum_age
        end
      
  end
end