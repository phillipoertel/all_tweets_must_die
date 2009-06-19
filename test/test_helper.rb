require 'rubygems'
require 'test/unit'
require 'mocha'
require 'redgreen' unless ENV['TM_FILENAME']

require 'rest_client'
require 'json'
require 'time'

module TweetFixtureProvider
  
  private
  
    def valid_tweet_data(attributes = {})
      tweets = JSON.parse(noradios_tweets_as_json)
      tweets[0].merge(attributes)
    end
    
    def noradios_tweets_as_json
      File.read(File.join(File.dirname(__FILE__), '../test/fixtures/user_timeline_noradio.json'))
    end
end
