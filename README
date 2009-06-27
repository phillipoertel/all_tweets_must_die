# Introduction

Hi there!

This library kills twitter messages of a given user once they are older than a given age. 

But you can add your custom tweet handlers (dsl/handlers.rb), so it can be used in completely different ways. Like automatically blogging all your tweets which you tagged with #blog, doing something else with the hashtag #quote, and so on.

To achieve this, all_tweets_must_die will go through your twitter timeline and run a TweetHandler on each tweet. The default TweetHandler will delete all tweets older than 12 hours, which can be modified by adding a hashtag like #keep24h (keeps it 24h) or just #keep (doesn't delete tweet at all).

# Disclaimer

* This is a private project and changes regularly. Use at your own risk. 
* By default, only 20 tweets are loaded from your timeline (twitter API default). This can be hacked in Runner#fetch_tweets though.
* when running periodically, it does not remember which tweets were already processed with the DSL, so if you don't delete them afterwards, the DSL action will be invoked again in the next run

## Important


# Usage

periodically execute these taks with cron. see examples/crontab.

* use rake run:killer to only run the regular killing behavior (as in lib/tweet_killer.rb)
* use rake run:dsl to only run stuff defined in dsl/handlers.rb
* use rake run:all to do both of the above


# Installation

## To use the rake tasks, create a file login.rb in the root and add

@login = {
  :user     => 'your_twitter_username',
  :password => 'your_twitter_password'
}

## Deployment

if you want to upload the app to a server, add the following to login.rb

@rsync_upload_uri = 'sh-username@servername:/directory/on/server'

# High-level implementation overview

The +Runner+ is called with a username, loads all tweets. Each tweet is loaded into a +Tweet+ instance and then all the registered +TweetHandlers+ are asked if they want to do anything with the tweet.
The TweetHandlers can be easily defined with a DSL. See dsl/handlers.rb for an example
require 'rest_client'
TweetHandler.add(/#blog/) do |hashtag, tweet|
  RestClient.post(create_blog_post_url, tweet.text)
end

# TODOS

* clean up DSL and make it more flexible (need to read a bit)
* rewrite the original #keep-handlers to be DSL-based instead of code-based, then throw out the add_handler method
* fix gem (require problem)
* require all needed files centrally, fixing the somewhat hacky requiring everywhere (what's the common ruby practise?)
* put configuration into yaml file and also allow loading it from shell environment variables
* use oauth
* write more handlers
