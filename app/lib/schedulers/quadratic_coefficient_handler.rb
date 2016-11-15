module Schedulers
  module QuadraticCoefficientHandler
  
    TYPES = %w(quadratic intensive moderate conservative hands_off)
    
    DEFAULT_COEFFICIENT = 2.0
    SPECIALIZED_COEFFICIENTS = {
      'intensive' => 1.0,
      'moderate' => 3.0,
      'conservative' => 4.0,
      'hands_off' => 5.0
    }
    
    def coefficient_for(schedule_type)
      (SPECIALIZED_COEFFICIENTS[schedule_type] || DEFAULT_COEFFICIENT)
    end
  end
end