Given(/^I am logged in as a system administrator$/) do
  @administrator = User.create!(name: "Administrator", 
                                administrator: true, 
                                email: "administrate@example.com", 
                                password: "password")
end

When(/^I visit the word list index and click "(.*?)"$/) do |arg1|
  visit word_lists_path
  click_link 'New Word list'
end

Then(/^I should be taken to a page to create new word lists$/) do
  visit new_word_list_path
end
