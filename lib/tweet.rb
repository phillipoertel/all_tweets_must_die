require 'rest_client'
require 'time'

module AllTweetsMustDie
  class Tweet
  
    def initialize(data)
      @data = data
      @data.created_at = Time.parse(@data.created_at)
    end
    
    def kill!
      Twitter.status_destroy(@data.id)
    end
    
    # in seconds
    def age
      Time.now.utc - @data.created_at
    end

    def text
      @data.text
    end
    
  end
end