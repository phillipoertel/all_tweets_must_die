require "rubygems"
require 'rest_client'
require 'time'
require '../lib/rtwitter'
require '../login'

#
# appropriate soundtracks: Miss Kittin -- Rippin Kittin; Kill Bill Vol. 1 & 2
#
class TweetKiller
  
  attr_reader :default_tweet_lifetime, :username, :password
  
  def initialize(options = {})
    @default_tweet_lifetime = options[:lifetime] || 12 # maximum allowed age in hours
    @username = options[:username]
    @password = options[:password]
  end
  
  def run!
    tweets = RTwitter::Status.new(:user => @username, :password => @password).user_timeline
    tweets.each do |tweet|
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
end