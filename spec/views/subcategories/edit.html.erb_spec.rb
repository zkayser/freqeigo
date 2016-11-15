require 'rails_helper'

RSpec.describe "subcategories/edit", type: :view do
  before(:each) do
    @subcategory = assign(:subcategory, Subcategory.create!(
      :subcategory => "MyText"
    ))
  end

  it "renders the edit subcategory form" do
    render

    assert_select "form[action=?][method=?]", subcategory_path(@subcategory), "post" do

      assert_select "textarea#subcategory_subcategory[name=?]", "subcategory[subcategory]"
    end
  end
end
