require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/regex_based_handler')


class InitializationTest < Test::Unit::TestCase

  include AllTweetsMustDie

  def test_should_not_call_the_block_if_the_tweet_text_doesnt_match_the_regex
    h = RegexBasedHandler.new(/ABC/, mock) # handing in an empty mock, i.e. expecting *nothing* to be called
    tweet = stub(:text => "La La Land")
    h.handle_tweet!(tweet)
  end

  def test_should_call_the_block_if_the_tweet_text_matches_the_regex
    h = RegexBasedHandler.new(/La/, mock(:call))
    tweet = stub(:text => "La La Land")
    h.handle_tweet!(tweet)
  end
end