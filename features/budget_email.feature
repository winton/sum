Feature: Budget email

  As a user
  I want to receive a budget email
  In order to know how much I can spend
  
  Scenario: I receive a budget email after creating an account
    Given I have not created an account
    When I visit the front page
    And submit a valid form
    And the background job runs
    Then I should receive an email