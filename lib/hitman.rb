require 'rubygems'
require 'rest_client'
require 'json'
require 'time'

require File.join(File.dirname(__FILE__), 'argument_validator')

#
# appropriate soundtracks: Miss Kittin -- Rippin Kittin; Kill Bill Vol. 1 & 2
#
module AllTweetsMustDie
  class Hitman
  
    include ArgumentValidator
    
    attr_reader :default_tweet_lifetime, :username, :password
    
    def initialize(options = {})
      validate_args!([:lifetime, :username, :password], options)
      @default_tweet_lifetime = options[:lifetime] || 12 # maximum allowed age in hours
      @username = options[:username]
      @password = options[:password]
    end
    
    def run!
      fetch_victim_tweets.each do |tweet|
        tweet.kill! unless tweet.should_live?(@default_tweet_lifetime)
      end
    end
    
    private
    
      def fetch_victim_tweets
        auth = (@username && @password) ? http_auth_string : ''
        response = RestClient.get("http://%stwitter.com/statuses/user_timeline/%s.json" % [auth, @username])
        JSON.parse(response).map { |tweet_data| Tweet.new(tweet_data) }
      end
    
      def http_auth_string
        "#{@username}:#{@password}@"
      end
      
  end
end