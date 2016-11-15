require 'rails_helper'

RSpec.describe "Categories", type: :request do
  
  before(:each) do
    Mongoid.purge!
  end
  
  describe "GET /categories" do
    it "works! (now write some real specs)" do
      login_as create(:user, admin?: true), scope: :user
      get categories_path
      expect(response).to have_http_status(200)
    end
  end
end
