module Schedulers
  class Exponential < Schedulers::Scheduler
    
    def advance
      @consecutive = @card.stats.cons_successful + 1
      add = 2 ** (2 + @consecutive)
      @card.schedule_manager.update_attribute(:next_due, Time.now + add.hours)
    end
    
  end
end