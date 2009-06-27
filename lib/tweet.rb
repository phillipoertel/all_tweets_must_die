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
      hashtag = @data['text'].match(/#keep((\d+)h)?$/)
      hashtag ? handle_with_hashtag(hashtag) : handle_without_hashtag(default_lifetime)
    end
    
    # in seconds
    def age
      Time.now.utc - @data['created_at']
    end
    
    private 
    
      # handles hashtags like "#keep" and "#keep24h"
      def handle_with_hashtag(match)
        return true if match[0] == "#keep"
        maximum_age = (match[2].to_i * 60 * 60)
        age <= maximum_age
      end
  
      def handle_without_hashtag(lifetime)
        maximum_age = (lifetime * 60 * 60)
        age <= maximum_age
      end
    
  end
end