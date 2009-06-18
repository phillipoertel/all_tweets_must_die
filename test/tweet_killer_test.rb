require 'rubygems'
require 'minitest/unit'

require '../lib/tweet_killer'

MiniTest::Unit.autorun
Test = MiniTest # minitest is API compatible

class InitializationTest < Test::Unit::TestCase
  def test_should_initialize_tweet_lifetime_to_12h_if_none_given
    killer = TweetKiller.new
    assert_equal 12, killer.default_tweet_lifetime
  end
  
  def test_should_accept_different_tweet_lifetime
    killer = TweetKiller.new(:lifetime => 42)
    assert_equal 42, killer.default_tweet_lifetime
  end
  
  def test_should_accept_and_store_username_and_password
    killer = TweetKiller.new(:username => 'phil76', :password => 'foo')
    assert_equal 'phil76', killer.username
    assert_equal 'foo', killer.password
  end
end