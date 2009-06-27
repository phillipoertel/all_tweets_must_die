#
# work in progress. far from being a DSL, but convenient callbacks.
#

# handles only tweets matching a given pattern
@runner.handle_hashtag(/#reboot/) do |hashtag, tweet|
  puts %(Here's a tweet about reboot: "#{tweet.text}")
end

# handles every tweet on the timeline
@runner.handle_each do |tweet|
  puts "%s... uses %s%% of available characters." % [tweet.text[0, 10], ((tweet.text.size.to_f/140) * 100).to_i]
end