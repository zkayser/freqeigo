require 'rails_helper'

RSpec.describe "word_lists/index", type: :view do
  before(:each) do
    assign(:word_lists, [
      WordList.create!(title: "title"),
    ])
  end

  it "renders a list of word_lists" do
    render
  end
  
  it "should have a link to create new word lists" do
    render
    expect(rendered).to have_content 'New Word list'
  end
end
