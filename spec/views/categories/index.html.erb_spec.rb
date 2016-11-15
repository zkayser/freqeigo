require 'rails_helper'

RSpec.describe "categories/index", type: :view do
  before(:each) do
    assign(:categories, [
      Category.create!(
        :category => "Category"
      ),
      Category.create!(
        :category => "Category"
      )
    ])
  end

  it "renders a list of categories" do
    render
    assert_select "tr>td", :text => "Category".to_s, :count => 2
  end
end
