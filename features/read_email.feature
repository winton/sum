Feature: Read email

  As a user
  I want to read a budget email
  In order to know how much I can spend
  
  Background:
    Given I have created an account with these attributes:
      | savings | income | bills |
      | 1000    | 5000   | 2500  |
    And a clear email queue
  
  Scenario: I see some static information every day
    Given it is midnight
    When the background job runs
    And I open the email
    Then I should see "Today's budget" in the subject
  
  Scenario: I see budget information for day 1
    Given it is day 1
    And it is midnight
    When the background job runs
    And I open the email
    Then I should see "Today's budget" in the subject