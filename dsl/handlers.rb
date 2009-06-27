#
# work in progress. far from being a DSL, but convenient callbacks.
#

# handles only tweets matching a given pattern
@runner.handle_hashtag(/#reboot/) do |hashtag, tweet|
  puts %(Here's a tweet about reboot: "#{tweet.text}")
end

# handles every tweet on the timeline
@runner.handle_each do |tweet|
  calc = lambda { |tweet| ((tweet.text.size.to_f/160) * 100).to_i }
  puts "'#{tweet.text[0, 40]}...' uses #{calc.call(tweet)}% of available characters."
end