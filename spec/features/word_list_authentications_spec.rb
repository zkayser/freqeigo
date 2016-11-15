require 'rails_helper'

RSpec.feature "Word list authentications", type: :feature do

  before(:each) do
    Mongoid.purge!
  end
  scenario "Creating a new word list as an admin user" do
    given_i_am_signed_in_as_an_admin
    when_i_go_to_the_word_list_index
    then_i_should_be_able_to_click_new_word_list
  end
  
  scenario "Visiting the word list index as a non-admin user" do
    given_i_am_signed_in_as_a_non_admin
    when_i_go_to_the_word_list_index
    then_i_should_be_redirected_to_the_home_page
  end
  
  scenario "Trying to visit the word list when not logged in" do
    given_i_am_not_signed_in
    when_i_go_to_the_word_list_index
    then_i_should_be_redirected_to_the_home_page
  end
  
  def given_i_am_signed_in_as_an_admin
    login_as create(:user, admin?: true), scope: :user
  end
  
  def when_i_go_to_the_word_list_index
    visit word_lists_path
  end
  
  def then_i_should_be_able_to_click_new_word_list
    expect(page).to have_content "Listing Word Lists"
  end
  
  def given_i_am_signed_in_as_a_non_admin
    login_as create(:user), scope: :user
  end
  
  def then_i_should_be_redirected_to_the_home_page
    expect(page).to have_content "Access denied."
  end
  
  def given_i_am_not_signed_in
    login_as(nil)
  end
end
