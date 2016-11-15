require 'rails_helper'

RSpec.describe "word_lists/new", type: :view do
  before(:each) do
    assign(:word_list, WordList.new)
  end

  it "renders new word_list form" do
    render
    assert_select "form[action=?][method=?]", word_lists_path, "post" do
    end
  end
  
  it "renders a field for the word_list title" do
    render
    expect(rendered).to have_selector("label", :text =>
                      "Title")
  end
  
  it "renders a nested form for words" do
    render
    expect(rendered).to have_content "Add Word"
  end
end
