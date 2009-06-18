require "rubygems"
require 'rest_client'
require 'time'
require 'lib/rtwitter'
require 'login'

killer = TweetKiller.new(:username => @login[:user], :password => @login[:password])
killer.run!