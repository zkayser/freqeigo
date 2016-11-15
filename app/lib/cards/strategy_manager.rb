module Cards
  class StrategyManager
    
    attr_accessor :strategy
    
    def initialize(card, strategy=Cards::Trajectories::DEFAULT_TRAJECTORY)
      @strategy = strategy
      @card = card
      @card.schedule_manager.master_stage = @strategy.keys.length
      @card.schedule_manager.strategy = @strategy
    end
        
    def find_current_stage
      @card.schedule_manager.stage
    end
    
    def review_bucket
      @card.schedule_manager.review_bucket
    end
    
    def current_array_to_use
      outside_key = @strategy.keys[(@card.schedule_manager.stage - 1)]
      outside_hash = @strategy[outside_key]
      inside_key = outside_hash.keys[(@card.schedule_manager.review_bucket - 1)]
      @strategy[outside_key][inside_key]
    end
    
    def fail_method
      self.current_array_to_use[0].to_s
    end
    
    def succeed_method
      self.current_array_to_use[1].to_s
    end
    
    def stage_changing_method?
      true if self.current_array_to_use.length == 3
    end
    
    def stage_changer_method
      self.current_array_to_use[2].to_s if stage_changing_method?
    end
  end
end