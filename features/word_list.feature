Feature: Creating word lists
  In order to create a list of words for users to study,
  as a system administrator,
  I want to be able to add words via a web interface to create word lists
  
Scenario: Opening a new word list page
  Given I am logged in as a system administrator
  When I visit the word list index and click "new word list"
  Then I should be taken to a page to create new word lists