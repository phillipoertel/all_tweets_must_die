require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/tweet_killer')
require File.join(File.dirname(__FILE__), '../lib/tweet')

class Fixnum
  def hours
    self * (60 * 60)
  end
end


class InitializationTest < Test::Unit::TestCase
  
  include AllTweetsMustDie
  
  def test_should_initialize_tweet_lifetime_to_12h_if_none_given
    assert_equal 12, TweetKiller.new.default_lifetime
  end
  
  def test_should_accept_different_tweet_lifetime
    killer = TweetKiller.new(:default_lifetime => 42)
    assert_equal 42, killer.default_lifetime
  end
  
  def test_should_accept_and_store_username_and_password
    killer = TweetKiller.new(:username => 'phil76', :password => 'foo')
    assert_equal 'phil76', killer.username
    assert_equal 'foo', killer.password
    assert_equal 12, killer.default_lifetime # default should also be set
  end
end


class TweetShouldLiveTest < Test::Unit::TestCase

  include AllTweetsMustDie
  include TweetFixtureProvider
  
  def test_should_live_if_tweet_is_6h_old_and_default_lifetime_is_12h
    tweet = Tweet.new(valid_tweet_data('created_at' => (Time.now - 6.hours).to_s, 'text' => 'Hello World'))
    default_lifetime = 12
    assert_equal true, TweetKiller.new.tweet_should_live?(tweet, default_lifetime)
  end
  
  def test_should_die_if_tweet_is_24h_old_and_default_lifetime_is_12h
    tweet = Tweet.new(valid_tweet_data('created_at' => (Time.now - 24.hours).to_s, 'text' => 'Hello World'))
    default_lifetime = 12
    assert_equal false, TweetKiller.new.tweet_should_live?(tweet, default_lifetime)
  end
  
  def test_should_live_if_tweet_is_20h_old_and_has_hashtag_with_keep24h
    tweet = Tweet.new(valid_tweet_data('created_at' => (Time.now - 20.hours).to_s, 'text' => 'Hello World #keep24h'))
    default_lifetime = 12
    assert_equal true, TweetKiller.new.tweet_should_live?(tweet, default_lifetime)
  end
  
  def test_should_die_if_tweet_is_8h_old_and_has_hashtag_with_keep6h
    tweet = Tweet.new(valid_tweet_data('created_at' => (Time.now - 8.hours).to_s, 'text' => 'Hello World #keep6h'))
    default_lifetime = 12
    assert_equal false, TweetKiller.new.tweet_should_live?(tweet, default_lifetime)
  end
  
  def test_should_live_if_the_keep_hashtag_is_given_without_time
    tweet = Tweet.new(valid_tweet_data('created_at' => (Time.now - 24.hours).to_s, 'text' => 'Hello World #keep'))
    default_lifetime = 12
    assert_equal true, TweetKiller.new.tweet_should_live?(tweet, default_lifetime)
  end

end