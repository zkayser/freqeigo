require 'rails_helper'

RSpec.describe EnrollmentsController, type: :controller do

  describe "GET #enroll" do
    it "returns http success" do
      get :enroll
      expect(response).to have_http_status(:success)
    end
  end

end
