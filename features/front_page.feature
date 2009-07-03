Feature: Front page 

  As a user
  I want to enter my information into a form
  In order to submit that information
  
  Scenario: User visits the front page
    When a user visits the front page
    Then they should see a form
    And they should see a "savings" text field
    And they should see an "income" text field
    And they should see a "bills" text field
    And they should see an "email" text field
    And they should see a submit button