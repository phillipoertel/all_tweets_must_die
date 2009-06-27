Hashtag.handle(/#keep/) do |hashtag, tweet|
  tweet.delete
end

Tweet
HashtagHandler => defines the action to be executed 
Runner