require 'rubygems'

require 'login'
Dir.glob('lib/*.rb').each { |file| require file }

hitman = AllTweetsMustDie::Hitman.new(:username => @login[:user], :password => @login[:password])
hitman.run!