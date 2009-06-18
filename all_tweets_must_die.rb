require 'rubygems'

require 'login'
require 'lib/tweet_killer'

TweetKiller.new(:username => @login[:user], :password => @login[:password]).run!
