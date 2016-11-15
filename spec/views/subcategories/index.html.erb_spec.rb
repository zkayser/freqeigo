require 'rails_helper'

RSpec.describe "subcategories/index", type: :view do
  before(:each) do
    assign(:subcategories, [
      Subcategory.create!(
        :subcategory => "MyText"
      ),
      Subcategory.create!(
        :subcategory => "MyText"
      )
    ])
  end

  it "renders a list of subcategories" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
