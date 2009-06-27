# Introduction

Hi there!

This library kills twitter messages of a given user once they are older than a given age. 

But you can add your custom tweet handlers (dsl/handlers.rb), so it can be used in completely different ways. Like automatically blogging all your tweets which you tagged with #blog, doing something else with the hashtag #quote, and so on.

To achieve this, all_tweets_must_die will go through your twitter timeline and run a TweetHandler on each tweet. The default TweetHandler will delete all tweets older than 12 hours, which can be modified by adding a hashtag like #keep24h (keeps it 24h) or just #keep (doesn't delete tweet at all).

The TweetHandlers can be easily defined with a DSL. See dsl/handlers.rb for an example
require 'rest_client'
TweetHandler.add(/#blog/) do |hashtag, tweet|
  RestClient.post(create_blog_post_url, tweet.text)
end

Then use rake run:dsl to execute the handlers on your timeline.

# Warning

* I'm happy if you find this code useful, This is a private project though and changes regularly. Use at your own risk.
* Only 20 tweets are loaded from your timeline (twitter API default). This can be hacked in Runner#fetch_tweets though.
* When running periodically, it does not remember which tweets were already processed. So if you don't delete tweets after processing, they will be processed again in the next run.

# Usage

run one of the rake run-tasks once or with cron. see examples/crontab.
Type rake -T run to see what's available.

# Installation

### To use the rake tasks, create a file called login.rb in the root and add

@login = {
  :user     => 'your_twitter_username',
  :password => 'your_twitter_password'
}

if you want to use rake deploy, add the following to login.rb (requires rsync and ssh access)

@rsync_upload_uri = 'ssh-username@servername:/directory/on/server'

# Implementation overview

The rake task starts the +Runner+ with a username and loads all tweets. Each tweet is loaded into a +Tweet+ instance and then all the registered +TweetHandlers+ are asked if they want to do anything with the tweet.


# TODOS

* clean up DSL and make it more flexible (need to read a bit)
* rewrite the original #keep-handlers to be DSL-based instead of code-based, then throw out the add_handler method
* fix gem (require problem)
* require all needed files centrally, fixing the somewhat hacky requiring everywhere (what's the common ruby practise?)
* put configuration into yaml file and also allow loading it from shell environment variables
* use oauth
* write more handlers
