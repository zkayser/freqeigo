require 'rails_helper'

RSpec.describe Cards::StageManager, type: :model do
  before(:each) do
    @deck = Deck.new(title: "deck")
    @card = Card.new(deck: @deck, top: "top", bottom: "bottom")
    @card.schedule_manager.stage = 1
    @manager = Cards::StageManager.new(@card)
  end
  
  context "on initialization" do
    it "reads the @card.stage attribute properly" do
      expect(@manager.stage).to eq(@card.schedule_manager.stage)
    end
    
    it "should start with the stage set to 1" do
      expect(@manager.stage).to eq(1)
    end
    
    it "should be able to assign a new stage manually" do
      @manager.stage = 2
      expect(@card.stage).to eq(2)
    end
    
    it "should increment @card.stage when calling #stage_up_if_pass" do
      @manager.stage_up_if_pass
      expect(@card.stage).to eq(2)
    end
    
    it "should decrement @card.stage when calling #stage_up_if_fail" do
      @card.schedule_manager.stage = 2
      @manager.stage_down_if_fail
      expect(@card.stage).to eq(1)
    end
    
    it "should set @card.stage equal to the length of keys in the trajectory when calling #set_master_stage_if_pass" do
      @strategy_manager = Cards::StrategyManager.new(@card, Cards::Trajectories::DEFAULT_TRAJECTORY)
      @manager.set_master_stage_if_pass
      expect(@card.stage).to eq(Cards::Trajectories::DEFAULT_TRAJECTORY.keys.length)
    end
  end
end