module Schedulers
  class Quadratic < Schedulers::Scheduler
    
    def initialize(card)
      super(card)
      @quadratic_coefficient = @card.schedule_manager.quadratic_coefficient
    end
    
    def advance
      @consecutive = @card.stats.cons_successful + 1
      add = (@quadratic_coefficient * @consecutive) ** 2
      @card.schedule_manager.update_attribute(:next_due, Time.now + add.hours)
    end
  end
end