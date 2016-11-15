module Cards
  module ScheduleTypeManager
    
    DEFAULT_TYPE = 'linear'
    SCHEDULE_TYPE_MAPPINGS = {
      'quadratic' => 'quadratic',
      'intensive' => 'quadratic',
      'moderate' => 'quadratic',
      'conservative' => 'quadratic',
      'hands_off' => 'quadratic',
      'exponential' => 'exponential'
    }
    
    def type_for(schedule_type)
      (SCHEDULE_TYPE_MAPPINGS[schedule_type] || schedule_type)
    end
    
    def set_quadratic_coefficient
      return nil unless self.schedule_type.in?(SCHEDULE_TYPE_MAPPINGS.keys)
      self.quadratic_coefficient = coefficient_for(self.schedule_type)
    end
  end
end