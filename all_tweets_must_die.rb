require "rubygems"
require 'rest_client'
require 'time'
require 'login'
require 'lib/tweet_killer'

killer = TweetKiller.new(:username => @login[:user], :password => @login[:password])
killer.run!