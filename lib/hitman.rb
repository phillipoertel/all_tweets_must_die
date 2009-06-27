require 'rubygems'
require 'rest_client'
require 'json'

require File.join(File.dirname(__FILE__), 'argument_validator')
require File.join(File.dirname(__FILE__), 'tweet_killer')

#
# appropriate soundtracks: Miss Kittin -- Rippin Kittin; Kill Bill Vol. 1 & 2
#
module AllTweetsMustDie
  class Hitman
  
    include ArgumentValidator
    
    attr_reader :default_lifetime, :username, :password
    
    def initialize(options = {})
      validate_args!([:default_lifetime, :username, :password], options)
      @default_lifetime = options[:default_lifetime] || 12 # maximum allowed age in hours
      @username = options[:username]
      @password = options[:password]
    end
    
    def run!
      killer = TweetKiller.new(@default_lifetime, @password)
      fetch_tweets.each do |tweet|
        killer.handle_tweet(tweet)
      end
    end
    
    private
    
      def fetch_tweets
        auth = @password ? "#{@username}:#{@password}@" : ''
        url = "http://%stwitter.com/statuses/user_timeline/%s.json" % [auth, @username]
        response = RestClient.get(url)
        JSON.parse(response).map { |one_tweet_data| Tweet.new(one_tweet_data) }
      end
      
  end
end