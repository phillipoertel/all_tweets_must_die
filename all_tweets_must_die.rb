require "rubygems"
require 'rest_client'
require 'time'
require 'lib/rtwitter'
require 'login'

# TODO write Tweet class and move this and the delete there.
def tweet_should_live?(tweet)
  hours_to_live = tweet['text'].match(/#keep(\d+)h$/)[1].to_i rescue 1
  has_lived = (Time.now.utc - Time.parse(tweet['text']))
  should_live = (hours_to_live * 60 * 60)
  has_lived < should_live
end

my_tweets = RTwitter::Status.new(:user => @login[:user], :password => @login[:password]).user_timeline
my_tweets.each do |tweet|
  next if tweet_should_live?(tweet)
  url = "http://%s:%s@twitter.com/statuses/destroy/%d.xml" % [@login[:user], @login[:password], tweet['id']]
  p url
  #RestClient.delete(url)
end