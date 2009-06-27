require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/tweet')

class Fixnum
  def hours
    self * (60 * 60)
  end
end

class ShouldLiveTest < Test::Unit::TestCase

  include AllTweetsMustDie
  include TweetFixtureProvider
  
  def test_should_live_if_tweet_is_6h_old_and_default_lifetime_is_12h
    data = valid_tweet_data('created_at' => (Time.now - 6.hours).to_s, 'text' => 'Hello World')
    default_lifetime = 12
    assert_equal true, Tweet.new(data).should_live?(default_lifetime)
  end
  
  def test_should_die_if_tweet_is_24h_old_and_default_lifetime_is_12h
    data = valid_tweet_data('created_at' => (Time.now - 24.hours).to_s, 'text' => 'Hello World')
    default_lifetime = 12
    assert_equal false, Tweet.new(data).should_live?(default_lifetime)
  end
  
  def test_should_live_if_tweet_is_20h_old_and_has_hashtag_with_keep24h
    data = valid_tweet_data('created_at' => (Time.now - 20.hours).to_s, 'text' => 'Hello World #keep24h')
    default_lifetime = 12
    assert_equal true, Tweet.new(data).should_live?(default_lifetime)
  end
  
  def test_should_die_if_tweet_is_8h_old_and_has_hashtag_with_keep6h
    data = valid_tweet_data('created_at' => (Time.now - 8.hours).to_s, 'text' => 'Hello World #keep6h')
    default_lifetime = 12
    assert_equal false, Tweet.new(data).should_live?(default_lifetime)
  end
  
  def test_should_live_if_the_keep_hashtag_is_given_without_time
    data = valid_tweet_data('created_at' => (Time.now - 24.hours).to_s, 'text' => 'Hello World #keep')
    default_lifetime = 12
    assert_equal true, Tweet.new(data).should_live?(default_lifetime)
  end

end


class KillTest < Test::Unit::TestCase

  include AllTweetsMustDie
  include TweetFixtureProvider

  def test_should_call_the_correct_url
    RestClient.expects(:delete).with('http://noradio:noradios_password@twitter.com/statuses/destroy/42.xml')
    Tweet.new(valid_tweet_data('id' => 42)).kill!('noradios_password')
  end
end