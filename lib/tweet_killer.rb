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
    user_timeline.each do |tweet|
      next if tweet_should_live?(tweet)
      url = "http://%s:%s@twitter.com/statuses/destroy/%d.xml" % [@username, @password, tweet['id']]
      RestClient.delete(url)
    end
  end
  
  private
  
    # TODO write Tweet class and move this and the delete there.
    def tweet_should_live?(tweet)
      hours_to_live = tweet['text'].match(/#keep(\d+)h$/)[1].to_i rescue @default_tweet_lifetime
      current_age = (Time.now.utc - Time.parse(tweet['created_at']))
      maximum_age = (hours_to_live * 60 * 60)
      current_age <= maximum_age
    end

    def user_timeline
      auth_string = (@username && @password) ? "#{@username}:#{@password}@" : ''
      response = RestClient.get("http://%stwitter.com/statuses/user_timeline/%s.json" % [auth_string, @username])
      JSON.parse(response)
    end
end