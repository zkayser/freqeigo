require 'rails_helper'

RSpec.describe Cards::StrategyManager, type: :model do
  
  before(:each) do
    @deck = Deck.new(title: "title")
    @card = Card.new(top: "top", bottom: "bottom")
    @card.schedule_manager.stage = 1
    @card.schedule_manager.review_bucket = 3
    @deck.cards << @card
    @manager = Cards::StrategyManager.new(@card)
  end
  
  context "on initialization" do
    it "returns the correct strategy" do
      expect(@manager.strategy).to eq(Cards::Trajectories::DEFAULT_TRAJECTORY)
    end
    
    it "returns the correct array to use when calling #current_array_to_use" do
      expect(@manager.current_array_to_use).to eq(Cards::Trajectories::DEFAULT_TRAJECTORY[:stage_one][:third_review])
    end
    
    it "returns a string with the correct fail method from the trajectory path" do
      expect(@manager.fail_method).to eq("reset")
    end
    
    it "returns a string with the correct fail method from the trajectory path" do
      expect(@manager.succeed_method).to eq("add_one_day")
    end
    
    it "returns a falsey value when calling #stage_changing_method? on a current_array_to_use with length not equal to 3" do
      expect(@manager.stage_changing_method?).to be_falsey
    end
    
    it "automatically sets the @card.master_stage level to the length of the strategy's keys" do
      expect(@card.master_stage).to eq(@manager.strategy.keys.length)
    end
  end
  
  context "when used with a card in a review bucket with a stage changing method" do
    
    before(:each) do
      @card.schedule_manager.review_bucket = 5
    end
    
    it "returns true when calling #stage_changing_method? on a current_array_to_use with length equal to 3" do
      expect(@manager.stage_changing_method?).to be true
    end
    
    it "returns a string with the correct stage_changer_method from the trajectory path if available" do
      expect(@manager.stage_changer_method).to eq("stage_up_if_pass")
    end
    
    it "returns nil when #stage_changer_method is called and #stage_changing_method? is falsey" do
      @card.schedule_manager.review_bucket = 4
      expect(@manager.stage_changer_method).to be_nil
    end
  end
end