require 'rubygems'
require 'rest_client'
require 'json'

require File.join(File.dirname(__FILE__), 'tweet_killer')
module AllTweetsMustDie
  
  # the Runner class loads the timeline of a given user
  # and gives every tweet to every registered TweetHandler
  class Runner
      
    include ArgumentValidator
    
    attr_reader :handlers

    def initialize(options)
      validate_args!([:username, :password, :handlers], options)
      @username = options[:username]
      @password = options[:password]
      @handlers = options[:handlers] || [TweetKiller.new(:username => @username, :password => @password)]
    end
    
    # TODO unify the add_* methods. need to read up on dsls
    def add_handler(handler)
      @handlers << handler
    end
    
    # TODO unify the add_* methods. need to read up on dsls
    def add_regex_handler(regex, &block)
      @handlers << RegexBasedHandler.new(regex, block)
    end
    alias_method :handle_hashtag, :add_regex_handler
    
    # TODO unify the add_* methods. need to read up on dsls
    def add_each_handler(&block)
      @handlers << BaseHandler.new(block)
    end
    alias_method :handle_each, :add_each_handler
    
    def run!
      fetch_tweets.each do |tweet|
         @handlers.each { |h| h.handle_tweet!(tweet) }
      end
    end
    
    private
    
      def fetch_tweets
        auth = @password ? "#{@username}:#{@password}@" : ''
        # to receive up to 200 tweets, add ?count=200 as request parameter
        url = "http://%stwitter.com/statuses/user_timeline/%s.json" % [auth, @username]
        response = RestClient.get(url)
        JSON.parse(response).map { |one_tweet_data| Tweet.new(one_tweet_data) }
      end
      
  end
end