require "rubygems"
require 'rest_client'
require 'time'
require 'lib/rtwitter'
require 'login'

DEFAULT_TWEET_AGE_IN_HOURS = 12

# TODO write Tweet class and move this and the delete there.
def tweet_should_live?(tweet)
  hours_to_live = tweet['text'].match(/#keep(\d+)h$/)[1].to_i rescue DEFAULT_TWEET_AGE_IN_HOURS
  current_age = (Time.now.utc - Time.parse(tweet['created_at']))
  maximum_age = (hours_to_live * 60 * 60)
  current_age <= maximum_age
end

my_tweets = RTwitter::Status.new(:user => @login[:user], :password => @login[:password]).user_timeline
my_tweets.each do |tweet|
  next if tweet_should_live?(tweet)
  url = "http://%s:%s@twitter.com/statuses/destroy/%d.xml" % [@login[:user], @login[:password], tweet['id']]
  RestClient.delete(url)
end