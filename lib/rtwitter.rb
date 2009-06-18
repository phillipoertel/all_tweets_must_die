require 'rubygems'
require 'rest_client'
require 'json'

require File.join(File.dirname(__FILE__), 'argument_validator')

module RTwitter
  class Status
    
    include ArgumentValidator
    
    def initialize(args = {})
      validate_args!([:user, :password], args)
      @user = args[:user]
      @password = args[:password]
    end
    
    def user_timeline(user_name = @user)
      auth_string = (@user && @password) ? "#{@user}:#{@password}@" : ''
      response = RestClient.get("http://%stwitter.com/statuses/user_timeline/%s.json" % [auth_string, user_name])
      JSON.parse(response)
    end
    
  end
end