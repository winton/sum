Feature: Receive email

  As a user
  I want to receive a budget email
  In order to read a budget email
  
  Background:
    Given my email queue is empty
  
  Scenario: I receive a budget email after creating an account
    Given I have not created an account
    When I visit the front page
    And I submit a valid form
    And the background job runs
    Then I should receive an email
  
  Scenario: I receive a budget email after updating an account
    Given I have created an account
    When I visit the front page
    And I submit a valid form
    And the background job runs
    Then I should receive an email
  
  Scenario: I receive a budget email at midnight
    Given I have created an account
    And it is midnight
    When the background job runs
    Then I should receive an email
  
  Scenario: I receive a budget email at midnight having added a transaction today
    Given I have created an account
    And today I have spent $1.00
    And the background job ran
    And my email queue is empty
    And it is midnight
    When the background job runs
    Then I should receive an email
    And spent today should be zero