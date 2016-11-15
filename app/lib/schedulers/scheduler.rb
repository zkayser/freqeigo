module Schedulers
  class Scheduler
    # Default scheduler super class. Uses a simple algorithm that advances
    # the card's next_due attribute by eight hours times the 
    # consecutive number of successes.
    
    def initialize(card)
      @card = card
    end
    
    def advance # Superclass method should be overridden.
      @consecutive = @card.stats.cons_successful + 1
      @card.schedule_manager.update_attribute(:next_due, Time.now + (@consecutive * 8).hours)
    end
  end
end