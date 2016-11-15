require 'rails_helper'

RSpec.describe "blogs/index", type: :view do
  before(:each) do
    assign(:blogs, [
      Blog.create!(
        :title => "Title",
        :author => "Author",
        :content => "Content",
        :picture => "Picture"
      ),
      Blog.create!(
        :title => "Title",
        :author => "Author",
        :content => "Content",
        :picture => "Picture"
      )
    ])
  end

  it "renders a list of blogs" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Author".to_s, :count => 2
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    assert_select "tr>td", :text => "Picture".to_s, :count => 2
  end
end
