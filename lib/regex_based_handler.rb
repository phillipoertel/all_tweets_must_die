module AllTweetsMustDie
  class RegexBasedHandler
    
    def initialize(regex, block)
      @regex = regex
      @block = block
    end
    
    def handle_tweet!(tweet)
      @tweet = tweet
      @block.call(tweet.text.match(@regex), tweet) if should_run?
    end
    
    private
    
      def should_run?
        @tweet.text.match(@regex)
      end
    
  end
end