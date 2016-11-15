require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #learn" do
    it "returns http success" do
      get :learn
      expect(response).to have_http_status(:success)
    end
  end

end
