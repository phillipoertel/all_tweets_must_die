require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/hitman')
require File.join(File.dirname(__FILE__), '../lib/tweet')

class InitializationTest < Test::Unit::TestCase
  
  include AllTweetsMustDie
  
  def test_should_initialize_tweet_lifetime_to_12h_if_none_given
    killer = Hitman.new
    assert_equal 12, killer.default_lifetime
  end
  
  def test_should_accept_different_tweet_lifetime
    killer = Hitman.new(:default_lifetime => 42)
    assert_equal 42, killer.default_lifetime
  end
  
  def test_should_accept_and_store_username_and_password
    killer = Hitman.new(:username => 'phil76', :password => 'foo')
    assert_equal 'phil76', killer.username
    assert_equal 'foo', killer.password
    assert_equal 12, killer.default_lifetime # default should also be set
  end
end


class RunTest < Test::Unit::TestCase

  include AllTweetsMustDie
  include TweetFixtureProvider
  
  def test_request_the_correct_users_timeline_when_updates_are_protected
    url = "http://noradio:foo@twitter.com/statuses/user_timeline/noradio.json"
    RestClient.expects(:get).with(url).returns("{}")
    Hitman.new(:username => 'noradio', :password => 'foo').run!
  end
  
  def test_request_the_correct_users_timeline_when_updates_are_public
    url = "http://twitter.com/statuses/user_timeline/noradio.json"
    RestClient.expects(:get).with(url).returns("{}")
    Hitman.new(:username => 'noradio').run!
  end
  
  # TODO decouple from implementation and make more specific
  def test_should_kill_tweets_older_than_allowed
    # fix the current time so we can operate on the canned tweets in the fixture
    Time.stubs(:now).returns(Time.parse("Fri Jun 19 14:23:07 +0200 2009"))
    
    RestClient.stubs(:get).returns(noradios_tweets_as_json)
    Tweet.any_instance.expects(:kill!).times(19) # 20 tweets in fixture. all but the latest tweets are older than 12h.
    Hitman.new(:username => 'noradio').run!
  end
end