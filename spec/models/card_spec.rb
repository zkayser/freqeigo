require 'rails_helper'

RSpec.describe Card, type: :model do
  before(:each) do
    @deck = Deck.new(title: "Deck")
    @card = Card.new(top: "Top material", bottom: "Bottom material")
    @deck.cards << @card
    Mongoid.purge!
  end
  
  context "querying basic attributes" do
    it "defaults reviewable to true" do
      expect(@card.schedule_manager.reviewable).to be true
    end
    
    it "defaults first_review? to true" do
      expect(@card.schedule_manager).to be_first_review
    end
    
    it "responds to #schedule_type" do
      expect(@card.schedule_manager.schedule_type).to eq("linear")
    end
    
    it "autobuilds a CardStatsHolder object" do
      expect(@card.stats).to_not be nil
    end
    
    it "autobuilds a ScheduleManager object" do
      expect(@card.schedule_manager).to_not be nil
    end
    
    it "autobuilds a RecoveryManager object" do
      expect(@card.recovery_manager).to_not be nil
    end
  end
  
  context "when updated via #succeed" do
    before(:each) do
      @card.succeed(@deck)
    end
    
    it "increments cons_successful by 1" do
      expect(@card.stats.cons_successful).to eq(1)
    end
    
    it "sets next due to approximately 8 hours from now" do
      expect(@card.schedule_manager.next_due).to be_between(Time.now + 7.hours + 59.minutes, Time.now + 8.hours + 1.minute)
    end
    
    it "increments overall_correct by 1" do
      expect(@card.stats.overall_correct).to eq(1)
    end
    
    it "increments overall_seen by 1" do
      expect(@card.stats.overall_seen).to eq(1)
    end
    
    it "sets reviewable to false" do
      expect(@card.schedule_manager.reviewable).to be false
    end
    
    it "increments @deck.current_seen by 1" do
      expect(@deck.current_seen).to eq(1)
    end
    
    it "increments @deck.current_correct by 1" do
      expect(@deck.current_correct).to eq(1)
    end
    
    it "updates @deck.last_current_update to Time.now" do
      expect(@deck.last_current_update).to be_between(Time.now - 20.seconds, Time.now)
    end
    
    it "increments @deck.total_correct by 1" do
      expect(@deck.total_correct).to eq(1)
    end
    
    it "increments @deck.total_seen by 1" do
      expect(@deck.total_seen).to eq(1)
    end
  end
  
  context "when updated via #failed" do
    before(:each) do
      @card.stats.cons_failed = 1
      @card.failed(@deck)
    end
    
    it "increments @deck.total_seen by 1" do
      expect(@deck.total_seen).to eq(1)
    end
    
    it "increments @deck.current_seen by 1" do
      expect(@deck.current_seen).to eq(1)
    end
    
    it "sets @deck.last_current_update to Time.now" do
      expect(@deck.last_current_update).to be_between(Time.now - 20.seconds, Time.now)
    end
    
    it "resets @card.cons_successful to 0" do
      expect(@card.stats.cons_successful).to eq(0)
    end
    
    it "increments @card.overall_seen by 1" do
      expect(@card.stats.overall_seen).to eq(1)
    end
    
    it "increases @card.failures by 1" do
      expect(@card.stats.failures).to eq(1)
    end
    
    it "set reviewable to true" do
      expect(@card.schedule_manager.reviewable).to be true
    end
    
    it "sets @card.next_due to Time.now" do
      expect(@card.schedule_manager.next_due).to be_between(Time.now - 20.seconds, Time.now)
    end
    
    it "increments @card.cons_failed" do
      expect(@card.stats.cons_failed).to eq(2)
    end
  end
  
  context "when using before create with quadratic schedule type" do
    it "sets a quadratic coefficient of 2 when schedule_type is 'quadratic'" do
      @card = Card.create(top: "top", bottom: "bottom", deck: @deck)
      @card.schedule_manager.schedule_type = "quadratic"
      @card.schedule_manager.save
      expect(@card.schedule_manager.quadratic_coefficient).to eq(2.0)
    end
    
    it "sets a quadratic_coefficient of 1 for schedule_type 'intensive'" do
      @card = Card.create(top: "top", bottom: "bottom", deck: @deck)
      @card.schedule_manager.schedule_type = "intensive"
      @card.schedule_manager.save
      expect(@card.schedule_manager.quadratic_coefficient).to eq(1.0)
      expect(@card.schedule_manager.schedule_type).to eq('quadratic')
    end
    
    it "sets a quadratic_coefficient of 3 for schedule_type 'moderate" do
      @card = Card.create(top: "top", bottom: 'bottom', deck: @deck)
      @card.schedule_manager.schedule_type = "moderate"
      @card.schedule_manager.save
      expect(@card.schedule_manager.quadratic_coefficient).to eq(3.0)
      expect(@card.schedule_manager.schedule_type).to eq('quadratic')
    end
  end
end
