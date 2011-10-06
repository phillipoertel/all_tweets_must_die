require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/tweet')

class KillTest < Test::Unit::TestCase

  include AllTweetsMustDie
  include TweetFixtureProvider

  def test_should_call_the_correct_url
    RestClient.expects(:delete).with('http://noradio:noradios_password@twitter.com/statuses/destroy/42.xml')
    Tweet.new(valid_tweet_data('id' => 42)).kill!('noradios_password')
  end
end