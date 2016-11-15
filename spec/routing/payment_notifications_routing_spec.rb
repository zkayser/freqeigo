require "rails_helper"

RSpec.describe PaymentNotificationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/payment_notifications").to route_to("payment_notifications#index")
    end

    it "routes to #new" do
      expect(:get => "/payment_notifications/new").to route_to("payment_notifications#new")
    end

    it "routes to #show" do
      expect(:get => "/payment_notifications/1").to route_to("payment_notifications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/payment_notifications/1/edit").to route_to("payment_notifications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/payment_notifications").to route_to("payment_notifications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/payment_notifications/1").to route_to("payment_notifications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/payment_notifications/1").to route_to("payment_notifications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/payment_notifications/1").to route_to("payment_notifications#destroy", :id => "1")
    end

  end
end
