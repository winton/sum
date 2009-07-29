Feature: Update user

  As a user
  I want to submit my information
  In order to see a success page
  
  Scenario: I submit a valid form with decimals
    When I visit the front page
    And I submit a valid form with decimals
    Then I should see a success page
  
  Scenario: I submit a valid form with numbers only
    When I visit the front page
    And I submit a valid form with numbers only
    Then I should see a success page
  
  Scenario: I submit a valid form with dollar signs
    When I visit the front page
    And I submit a valid form with dollar signs
    Then I should see a success page
  
  Scenario: I submit an invalid savings amount
    When I visit the front page
    And submit an invalid savings amount
    Then I should see a form
    And the savings field should have an error
    And the error should be "is not a number"
  
  Scenario: I submit an empty savings amount
    When I visit the front page
    And submit an empty savings amount
    Then I should see a form
    And the savings field should have an error
    And the error should be "is not a number"
  
  Scenario: I submit an invalid income amount
    When I visit the front page
    And submit an invalid income amount
    Then I should see a form
    And the income field should have an error
    And the error should be "is not a number"
  
  Scenario: I submit an empty income amount
    When I visit the front page
    And submit an empty income amount
    Then I should see a form
    And the income field should have an error
    And the error should be "is not a number"

  Scenario: I submit an invalid bills amount
    When I visit the front page
    And submit an invalid bills amount
    Then I should see a form
    And the bills field should have an error
    And the error should be "is not a number"

  Scenario: I submit an empty bills amount
    When I visit the front page
    And submit an empty bills amount
    Then I should see a form
    And the bills field should have an error
    And the error should be "is not a number"
    
  Scenario: I submit an invalid email
    When I visit the front page
    And submit an invalid email
    Then I should see a form
    And the email field should have an error
    And the error should be "is invalid"
  
  Scenario: I submit an empty email
    When I visit the front page
    And submit an empty email
    Then I should see a form
    And the email field should have an error
    And the error should be "can't be blank"
  
  Scenario: I don't check the terms of service
    When I visit the front page
    And submit an empty tos
    Then I should see a form
    And the tos field should have an error
    And the error should be "must be accepted"