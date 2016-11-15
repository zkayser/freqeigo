require 'rails_helper'

RSpec.describe "subcategories/show", type: :view do
  before(:each) do
    @subcategory = assign(:subcategory, Subcategory.create!(
      :subcategory => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
  end
end
