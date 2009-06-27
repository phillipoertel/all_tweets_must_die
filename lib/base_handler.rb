module AllTweetsMustDie
  class BaseHandler
    
    def initialize(block)
      @block = block
    end
    
    def handle_tweet!(tweet)
      @block.call(tweet)
    end
    
  end
end