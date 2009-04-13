require 'rubygems'
require 'rest_client'
require 'json'

module RTwitter
  class Status
    
    def initialize(args = {})
      validate_args!(VALID_INITIALIZE_ARGS, args)
      @user = args[:user]
      @password = args[:password]
    end
    VALID_INITIALIZE_ARGS = [:user, :password]
    
    def user_timeline(user_name = @user)
      auth_string = (@user && @password) ? "#{@user}:#{@password}@" : ''
      response = RestClient.get("http://%stwitter.com/statuses/user_timeline/%s.json" % [auth_string, user_name])
      JSON.parse(response)
    end
    
    private 
    
      # fail early, don't swallow unknown arguments
      def validate_args!(valid_args, actual_args)
        raise ArgumentError unless actual_args.keys.all? { |arg| valid_args.include?(arg) }
      end
  end
end