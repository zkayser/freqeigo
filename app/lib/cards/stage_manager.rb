module Cards
  class StageManager
    
    def initialize(card)
      @card = card
    end
    
    def stage
      @card.schedule_manager.stage
    end
    
    def stage=(other_stage)
      @card.schedule_manager.stage = other_stage
      @card.save
    end
    
    def stage_up_if_pass
      @card.schedule_manager.inc(stage: 1)
    end
    
    def stage_down_if_fail
      @card.schedule_manager.inc(stage: -1) unless @card.schedule_manager.stage == 1
    end
    
    def set_master_stage_if_pass
      @card.schedule_manager.stage = @card.schedule_manager.master_stage
    end
    
    def reset
      if self.stage > 1 && @card.schedule_manager.review_bucket > 1 && self.stage != @card.schedule_manager.master_stage
        @card.schedule_manager.inc(review_bucket: -1)
      elsif self.stage > 1 && @card.schedule_manager.review_bucket == 1
        @strategy_manager = StrategyManager.new(@card, @card.schedule_manager.strategy)
        self.send(@strategy_manager.stage_changer_method.to_sym)
      else
        @card
      end
      @card.schedule_manager.update_attribute(:next_due, Time.now)
    end
  end
end