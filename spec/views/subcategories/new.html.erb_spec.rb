require 'rails_helper'

RSpec.describe "subcategories/new", type: :view do
  before(:each) do
    assign(:subcategory, Subcategory.new(
      :subcategory => "MyText"
    ))
  end

  it "renders new subcategory form" do
    render

    assert_select "form[action=?][method=?]", subcategories_path, "post" do

      assert_select "textarea#subcategory_subcategory[name=?]", "subcategory[subcategory]"
    end
  end
end
