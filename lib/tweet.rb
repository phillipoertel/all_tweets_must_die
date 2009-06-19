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
    
    def should_live?(default_lifetime)
      keep_hashtag = @data['text'].match(/#keep(\d+)h$/)
      hours_to_live = keep_hashtag ? keep_hashtag[1].to_i : default_lifetime
      current_age = Time.now.utc - @data['created_at']
      maximum_age = (hours_to_live * 60 * 60)
      current_age <= maximum_age
    end
  
  end
end