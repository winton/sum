Feature: Update user

  As a user
  I want to submit my information
  In order to see a success page
  
  Scenario: User submits a valid form with decimals
    When a user visits the front page
    And submits a valid form with "decimals"
    Then they should see a success page
  
  Scenario: User submits a valid form with numbers only
    When a user visits the front page
    And submits a valid form with "numbers only"
    Then they should see a success page
  
  Scenario: User submits a valid form with dollar signs
    When a user visits the front page
    And submits a valid form with "dollar signs"
    Then they should see a success page
  
  Scenario: User submits an invalid savings amount
    When a user visits the front page
    And submits an invalid "savings" amount
    Then they should see a form
    And the "savings" field should have an error
    And the error should be "is not a number"
  
  Scenario: User submits an empty savings amount
    When a user visits the front page
    And submits an empty "savings" amount
    Then they should see a form
    And the "savings" field should have an error
    And the error should be "is not a number"
  
  Scenario: User submits an invalid income amount
    When a user visits the front page
    And submits an invalid "income" amount
    Then they should see a form
    And the "income" field should have an error
    And the error should be "is not a number"
  
  Scenario: User submits an empty income amount
    When a user visits the front page
    And submits an empty "income" amount
    Then they should see a form
    And the "income" field should have an error
    And the error should be "is not a number"

  Scenario: User submits an invalid bills amount
    When a user visits the front page
    And submits an invalid "bills" amount
    Then they should see a form
    And the "bills" field should have an error
    And the error should be "is not a number"

  Scenario: User submits an empty bills amount
    When a user visits the front page
    And submits an empty "bills" amount
    Then they should see a form
    And the "bills" field should have an error
    And the error should be "is not a number"
    
  Scenario: User submits an invalid email
    When a user visits the front page
    And submits an invalid "email"
    Then they should see a form
    And the "email" field should have an error
    And the error should be "is invalid"
  
  Scenario: User submits an empty email
    When a user visits the front page
    And submits an empty "email"
    Then they should see a form
    And the "email" field should have an error
    And the error should be "can't be blank"