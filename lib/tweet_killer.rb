require 'rubygems'
require 'rest_client'
require 'json'
require 'time'

require File.join(File.dirname(__FILE__), 'argument_validator')

#
# appropriate soundtracks: Miss Kittin -- Rippin Kittin; Kill Bill Vol. 1 & 2
#
class TweetKiller

  include ArgumentValidator
  
  attr_reader :default_tweet_lifetime, :username, :password
  
  def initialize(options = {})
    validate_args!([:lifetime, :username, :password], options)
    @default_tweet_lifetime = options[:lifetime] || 12 # maximum allowed age in hours
    @username = options[:username]
    @password = options[:password]
  end
  
  def run!
    user_timeline.each do |tweet_data|
      tweet = Tweet.new(tweet_data)
      tweet.kill! unless tweet.should_live?(@default_tweet_lifetime)
    end
  end
  
  private
  
    def user_timeline
      puts "fetching timeline"
      auth_string = (@username && @password) ? http_auth_string : ''
      response = RestClient.get("http://%stwitter.com/statuses/user_timeline/%s.json" % [auth, @username])
      JSON.parse(response)
    end
  
    def http_auth_string
      "#{@username}:#{@password}@"
    end
    
end