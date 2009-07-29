Feature: Front page 

  As a user
  I want to enter my information into a form
  In order to submit that information
  
  Scenario: I visit the front page
    When I visit the front page
    Then I should see a form
    And I should see a savings text field
    And I should see an income text field
    And I should see a bills text field
    And I should see an email text field
    And I should see a tos checkbox
    And I should see a submit button