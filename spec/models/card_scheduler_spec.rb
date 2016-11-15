require 'rails_helper'

RSpec.describe CardScheduler, type: :model do
  before(:each) do
      @deck = Deck.new(title: "whatever deck")
      @card = Card.new(top: "top", bottom: "bottom", deck: @deck)
      @card.schedule_manager.master_stage = 4
      @scheduler = CardScheduler.new(@card)
    end
  
  context "when scheduling a Stage 1 card" do
  
    it "reads last_ten and returns true if five fails or more on #five_for_ten" do
      @card.stats.last_ten = %w(pass fail pass fail pass fail pass fail pass fail)
      @scheduler = CardScheduler.new(@card)
      expect(@scheduler.last_ten_percentage).to eq(50) # Why does your scheduler know about the last 10 percentage?
    end
  end
  
  context "when setting recovery strategies" do
  end
  
  context "when in recovery mode" do
    it "returns true for @card.in_recovery? when in one of the three recovery modes" do
      @card.stats.cons_failed = 3
      @scheduler.set_recovery_strategy
      expect(@card.recovery_manager).to be_in_recovery
    end
  end
  
  context "when making calls that should be picked up by method_missing" do
    it "catches calls that have the format add_xxx_hours" do
      @scheduler.add_five_hours
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 4.hours + 58.minutes, Time.now + 5.hours)
    end
    
    it "catches calls that have the format add_xxx_day_and_yyy_hours" do
      @scheduler.add_one_day_and_five_hours
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 1.day + 4.hours + 59.minutes, Time.now + 1.day + 5.hours)
    end
    
    it "catches calls that have the format add_xxx_days" do
      @scheduler.add_two_days
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 1.day + 23.hours + 59.minutes, Time.now + 2.days)
    end
    
    it "catches calls that have the format add_xxx_days_and_yyy_hours" do
      @scheduler.add_five_days_and_two_hours
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 5.days + 1.hour + 59.minutes, Time.now + 5.days + 2.hours)
    end
    
    it "catches calls that have the format xx_per_day" do
      @scheduler.one_per_day
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 23.hours + 59.minutes, Time.now + 1.day)
    end
    
    it "catches calls that have the format xx_per_month" do
      @scheduler.one_per_month
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 30.days - 1.minute, Time.now + 30.days)
    end
    
    it "catches calls that have the format xx_per_year" do
      @scheduler.one_per_year
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 12.months - 1.hour, Time.now + 12.months)
    end
    
    it "catches calls that have the format xx_per_hour" do
      @scheduler.one_per_hour
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 1.hour - 1.minute, Time.now + 1.hour)
    end
    
    it "raises an InvalidTimePeriodError exception when called with any period except year, month, day, or hour" do
      expect{@scheduler.one_per_minute}.to raise_error(Cards::InvalidTimeError)
    end
  end
  
  context "when calling schedule_card on a card with linear schedule_type" do
    
    before(:each) do
      @card.schedule_manager.update_attribute(:schedule_type, "linear")
    end
    
    it "sets the @card's next_due review date to 8 hours later by default for the first review when passed" do
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 7.hours + 59.minutes, Time.now + 8.hours)
    end
    
    it "sets the @card's next_due review date to 16 hours later with no failures on 2 straight successes" do
      @card.stats.update_attribute(:cons_successful, 1) # This attribute gets incremented on #succeed, so 1 is added to it in calculating review interval
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 15.hours + 59.minutes, Time.now + 16.hours)
    end
    
    it "sets the @card's next_due to 24 hours later with no failures on 3 straight successes" do
      @card.stats.update_attribute(:cons_successful, 2)
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 23.hours + 59.minutes, Time.now + 24.hours)
    end
    
    it "sets the @card's next_due review date to 16 hours from now with 2 straight successes but 1 failure" do
      @card.stats.update_attributes(
        cons_successful: 1,
        overall_correct: 2
        )
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 15.hours + 59.minutes, Time.now + 16.hours)
    end
  end
  
  context "when calling #schedule_card on a card with exponential schedule_type" do
    # Things get out of hand quickly with this algorithm
    before(:each) do
      @card.schedule_manager.update_attribute(:schedule_type, "exponential")
      @scheduler.update_scheduler_type
    end
    
    it "sets the @card's next_due review date to 8 hours from now on the first success" do
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 7.hours + 59.minutes, Time.now + 8.hours)
    end
    
    it "sets the @card's next_due review date to 16 hours from now on 2 consecutive successes" do
      @card.stats.update_attribute(:cons_successful, 1) # Updated to 2 in call to succeed after scheduling
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 15.hours + 59.minutes, Time.now + 16.hours)
    end
    
    it "sets the @card's next_due review date to 32 hours from now on 3 consecutive successes" do
      @card.stats.update_attribute(:cons_successful, 2)
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 31.hours + 59.minutes, Time.now + 32.hours)
    end
  end
  
  context "when calling #schedule_card on a card with quadratic schedule_type and quadratic_coefficient of 3" do
    
    before(:each) do
      @card.schedule_manager.update_attribute(:schedule_type, "quadratic")
      @card.schedule_manager.quadratic_coefficient = 3.0
      @scheduler.update_scheduler_type
    end
    
    it "sets the @card's next_due review date to 9 hours later on initial success" do
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 8.hours + 59.minutes, Time.now + 9.hours)
    end
    
    it "sets the @card's next_due review date to 36 hours later on 2 consecutive successes" do
      @card.stats.update_attribute(:cons_successful, 1)
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 35.hours + 59.minutes, Time.now + 36.hours)
    end
    
    it "sets the @card's next_due review_date to 81 hours later on 3 consecutive successes" do
      @card.stats.update_attribute(:cons_successful, 2)
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 80.hours + 59.minutes, Time.now + 81.hours)
    end
  end
  
  context "when calling #schedule_card on a card with quadratic schedule_type and quadratic_coefficient of 2" do
    
    before(:each) do
      @card.schedule_manager.update_attribute(:schedule_type, "quadratic")
      @card.schedule_manager.update_attribute(:quadratic_coefficient, 2.0)
      @scheduler.update_scheduler_type
    end
    
    it "sets the @card's next_due review date to 4 hours later on initial success" do
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 3.hours + 59.minutes, Time.now + 4.hours)
    end
    
    it "sets the @card's next_due review date to 16 hours later on second consecutive success" do
      @card.stats.update_attribute(:cons_successful, 1)
      @scheduler.advance
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 15.hours + 59.minutes, Time.now + 16.hours)
    end
  end
end