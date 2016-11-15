require 'rails_helper'

RSpec.describe "Subcategories", type: :request do
  
  before(:each) do
    Mongoid.purge!
  end
  
  describe "GET /subcategories" do
    it "works! (now write some real specs)" do
      @category = Category.create!(category: "Some category")
      get category_subcategories_path(@category.id)
      expect(response).to have_http_status(200)
    end
  end
end
