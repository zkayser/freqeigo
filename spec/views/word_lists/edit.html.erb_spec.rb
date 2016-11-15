require 'rails_helper'

RSpec.describe "word_lists/edit", type: :view do
  before(:each) do
    @word_list = assign(:word_list, WordList.create!(title: "title"))
  end

  it "renders the edit word_list form" do
    render

    assert_select "form[action=?][method=?]", word_list_path(@word_list), "post" do
    end
  end
end
