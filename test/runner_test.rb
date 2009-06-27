require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/runner')
require File.join(File.dirname(__FILE__), '../lib/tweet')


class RunTest < Test::Unit::TestCase

  include AllTweetsMustDie
  include TweetFixtureProvider
  
  def test_request_the_correct_users_timeline_when_updates_are_protected
    url = "http://noradio:foo@twitter.com/statuses/user_timeline/noradio.json"
    RestClient.expects(:get).with(url).returns("{}")
    Runner.new(:username => 'noradio', :password => 'foo').run!
  end
  
  def test_request_the_correct_users_timeline_when_updates_are_public
    url = "http://twitter.com/statuses/user_timeline/noradio.json"
    RestClient.expects(:get).with(url).returns("{}")
    Runner.new(:username => 'noradio').run!
  end
  
  def test_should_process_all_tweets_in_timeline
    RestClient.stubs(:get).returns(noradios_tweets_as_json)
    runner = Runner.new(:username => 'noradio')
    TweetKiller.any_instance.expects(:handle_tweet!).times(20)
    runner.run!
  end
  
  # TODO decouple from implementation and make more specific
  # TODO separate 
  def test_should_kill_tweets_older_than_allowed
    # fix the current time so we can operate on the canned tweets in the fixture
    Time.stubs(:now).returns(Time.parse("Fri Jun 19 14:23:07 +0200 2009"))
    
    RestClient.stubs(:get).returns(noradios_tweets_as_json)
    Tweet.any_instance.expects(:kill!).times(19) # 20 tweets in fixture. all but the latest tweets are older than 12h.
    Runner.new(:username => 'noradio').run!
  end
end

class AddHandlerTest < Test::Unit::TestCase
  
  include AllTweetsMustDie

  def test_should_have_tweet_killer_as_default_handler
    runner = Runner.new(:username => 'noradio')
    assert_equal TweetKiller, runner.handlers.first.class
    assert_equal 1, runner.handlers.size
  end

  def test_should_add_tweet_handlers
    runner = Runner.new(:username => 'noradio')
    assert_equal 1, runner.handlers.size
    runner.add_handler(stub(:handle_tweet! => nil)) # at the moment, this could be anything, interface is not checked.
    assert_equal 2, runner.handlers.size
  end
end