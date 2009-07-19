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

  Scenario: I receive a budget email at the end of the month
    Given today is June 1, 2009
    And I have created an account
    And today I have spent $1.00
    And today is July 1, 2009
    And it is midnight
    When the background job runs
    And I open the email
    Then spent today should be zero
    And I should see in the email:
      """
      You need to earn $0.03 today.
      """
      # tests User#temporary_spending_cut
    And I should see in the email:
      """
      Fiscal month: 07/01/09 to 08/01/09
      """
    And output the email
    