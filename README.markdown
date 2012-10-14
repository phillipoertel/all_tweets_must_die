# Introduction

This library deletes your tweets after some time. The default ist 12 hours, but you can chance this by adding a hashtag like `#keep24h` (keeps it 24 hours) to your tweet. Just adding `#keep` will keep the tweet forever.

There are some beginnings of other `TweetHandlers` in the code. The ideas is that you write a simple Ruby class that will be applied to tweet on your timeline. Some examples are: automatically blogging all your tweets tagged with `#blog`, doing something else with the hashtag `#quote`, and so on. See  `dsl/handlers.rb` for how this works.

Then use `rake run:dsl` to execute the handlers on your timeline. Of course this needs to be done periodically

# Warning

* I wrote this for myself and it isn't really built to run in different environments of preferences. See also: opinionated software :-) Use at your own risk. Hack it as you like.
* Only 20 tweets are loaded from your timeline (this is the twitter API default). Until I add a setter, this can be hacked in `Runner#fetch_tweets`.
* When running periodically, it does not remember which tweets were already processed. So tweets will be processed again in the next run, if if you don't delete tweets after processing.

# Usage

run one of the `rake run`-tasks once or repeatedly with cron. see `examples/crontab`.
Type `rake -T run` to see what's available.

# Installation

### The library doesn't use OAuth, so it needs to be configured with your login credentials. So to use the rake tasks, create a file called login.rb in the root and add

  @login = {
    :user     => 'your_twitter_username',
    :password => 'your_twitter_password'
  }
  
if you want to use `rake deploy`, add the following to login.rb (requires rsync and ssh access)

  @rsync_upload_uri = 'ssh-username@servername:/directory/on/server'

# Implementation overview

The rake task starts the `Runner` with a username and loads all tweets. Each tweet is loaded into a `Tweet` instance and then all the registered `TweetHandlers` are asked if they want to do anything with the tweet.


# TODOS

* clean up DSL and make it more flexible 
* rewrite the original #keep-handlers to be DSL-based instead of code-based, then throw out the add_handler method
* fix gem (require problem)
* require all needed files centrally, fixing the somewhat hacky requiring everywhere (what's the common ruby practise?)
* put configuration into yaml file and also allow loading it from shell environment variables
* use oauth
* write more handlers
