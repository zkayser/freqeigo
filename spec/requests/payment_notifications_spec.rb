require 'rails_helper'

RSpec.describe "PaymentNotifications", type: :request do
  
  before(:each) do
    Mongoid.purge!
  end
  
  describe "GET /payment_notifications" do
    it "works! (now write some real specs)" do
      login_as create(:user, admin?: true), scope: :user
      get payment_notifications_path
      expect(response).to have_http_status(200)
    end
  end
end
