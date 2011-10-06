require 'rubygems'
require 'rest_client'
require 'json'
require 'twitter'

require File.join(File.dirname(__FILE__), 'tweet_killer')
module AllTweetsMustDie
  
  # the Runner class loads the timeline of a given user
  # and gives every tweet to every registered TweetHandler
  class Runner
      
    include ArgumentValidator
    
    attr_reader :handlers

    def initialize(options = {})
      validate_args!([:handlers], options)
      @handlers = options[:handlers] || [TweetKiller.new]
    end
    
    def add_handler(handler)
      @handlers << handler
    end
    
    def add_regex_handler(regex, &block)
      @handlers << RegexBasedHandler.new(regex, block)
    end
    alias_method :handle_hashtag, :add_regex_handler
    
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
        options = {:count => 100, :trim_user => true, :include_rts => true}
        timeline = Twitter.user_timeline(Twitter.user.screen_name, options)
        timeline.map { |data| Tweet.new(data) }
      end
      
  end
end