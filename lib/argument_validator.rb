module AllTweetsMustDie
  module ArgumentValidator
    
    private
    
      # fail early, don't swallow unknown arguments.
      # especially useful for named parameter style argument passing
      def validate_args!(valid_args, actual_args)
        invalid_args = actual_args.keys - valid_args
        unless invalid_args.empty?
          msg = "Invalid argument(s) %s. Valid are: %s" % [format_args(invalid_args), format_args(valid_args)]
          raise ArgumentError.new(msg)
        end
      end
      
      def format_args(args)
        args.sort { |a1, a2| a1.to_s <=> a2.to_s }.map { |a| %("#{a}") }.join(', ')
      end
  end 
end