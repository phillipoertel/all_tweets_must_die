require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/tweet')

module TweetTestHelper
  private
    def valid_tweet_data(attributes = {})
      json = File.read(File.join(File.dirname(__FILE__), '../test/fixtures/user_timeline_noradio.json'))
      tweets = JSON.parse(json)
      tweets[0].merge(attributes)
    end
end

class ShouldLiveTest < Test::Unit::TestCase

  include TweetTestHelper
  
  def test_should_live_if_tweet_is_6h_old_and_default_lifetime_is_12h
    data = valid_tweet_data('created_at' => (Time.now - (6 * (60 * 60))).to_s, 'text' => 'Hello World')
    default_lifetime = 12
    assert_equal true, Tweet.new(data).should_live?(default_lifetime)
  end
  
  def test_should_die_if_tweet_is_24h_old_and_default_lifetime_is_12h
    data = valid_tweet_data('created_at' => (Time.now - (24 * (60 * 60))).to_s, 'text' => 'Hello World')
    default_lifetime = 12
    assert_equal false, Tweet.new(data).should_live?(default_lifetime)
  end
  
  def test_should_live_if_tweet_is_20h_old_and_has_hashtag_with_keep24h
    data = valid_tweet_data('created_at' => (Time.now - (6 * (60 * 60))).to_s, 'text' => 'Hello World #keep24h')
    default_lifetime = 12
    assert_equal true, Tweet.new(data).should_live?(default_lifetime)
  end
  
  def test_should_die_if_tweet_is_20h_old_and_has_hashtag_with_keep6h
    data = valid_tweet_data('created_at' => (Time.now - (6 * (60 * 60))).to_s, 'text' => 'Hello World #keep6h')
    default_lifetime = 12
    assert_equal false, Tweet.new(data).should_live?(default_lifetime)
  end

end


class KillTest < Test::Unit::TestCase

  include TweetTestHelper

  def test_should_call_the_correct_url
    RestClient.expects(:delete).with('http://noradio:noradios_password@twitter.com/statuses/destroy/42.xml')
    Tweet.new(valid_tweet_data('id' => 42)).kill!('noradios_password')
  end
end