require File.join(File.dirname(__FILE__), '../test/test_helper')
require File.join(File.dirname(__FILE__), '../lib/base_handler')


class InitializationTest < Test::Unit::TestCase

  include AllTweetsMustDie

  def test_should_be_initialized_with_a_block_and_call_it_to_handle_tweet
    h = BaseHandler.new(mock(:call))
    h.handle_tweet!(mock)
  end
end