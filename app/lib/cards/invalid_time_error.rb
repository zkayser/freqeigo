module Cards
  class InvalidTimeError < StandardError
    
    def initialize(msg= "Time period is invalid. Try year, month, day, or hour")
      @msg = msg
    end
    
  end
end