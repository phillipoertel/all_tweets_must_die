require 'rest_client'
require 'time'

module AllTweetsMustDie
  class Tweet
  
    def initialize(data)
      @data = data
      @data['created_at'] = Time.parse(@data['created_at'])
    end
    
    def kill!(password)
      http_auth_string = "#{@data['user']['screen_name']}:#{password}@"
      url = "http://%stwitter.com/statuses/destroy/%d.xml" % [http_auth_string, @data['id']]
      RestClient.delete(url)
    end
    
    # in seconds
    def age
      Time.now.utc - @data['created_at']
    end

    def text
      @data['text']
    end
    
  end
end