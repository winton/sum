Feature: Read email

  As a user
  I want to read a budget email
  In order to know how much I can spend
  
  Background:
    Given today is June 1, 2009
    And I have created an account with these attributes:
      | savings | income | bills |
      | 1000    | 5000   | 2500  |
      # income - bills - savings = 1500 (spending money)
    And my email queue is empty
  
  Scenario: I see some static information every day
    Given it is midnight
    When the background job runs
    And I open the email
    Then I should see "Today's budget" in the subject
    And I should see "Fiscal month: 06/01/09 to 07/01/09" in the email
    
  # Day 1
  
  Scenario: I see budget information for day 1, having spent nothing today
    Given it is day 1
    And it is midnight
    When the background job runs
    And I open the email
    Then I should see "You can spend $50.00 today" in the email
      # days in month = 30
      # spending money / days in month = 50
    And I should see "If you don't spend anything today, you will have" in the email
    And I should see "  $51.72 to spend each day" in the email
      # days left = 29
      # spending money / days left = 51.72
    And I should see "  $362.07 to spend each week" in the email
      # spending money / days left * 7 = 362.07
    And I should see "  $1500.00 to spend over the next 29 days" in the email
    And I should see "You have saved $50.00 more than expected for a 1 day period" in the email
  
  Scenario: I see budget information for day 1, having deposited money
    Given it is day 1
    And it is midnight
    And I have deposited $1.00
    When the background job runs
    And I open the email
    Then I should see "You can spend $51.00 today" in the email
      # (spending money / days in month) - spent today = 51
    And I should see "If you don't spend anything today, you will have" in the email
    And I should see "  $51.76 to spend each day" in the email
    And I should see "  $362.31 to spend each week" in the email
    And I should see "  $1501.00 to spend over the next 29 days" in the email
      # spending money + 1 = 1501
    And I should see "You have saved $51.00 more than expected for a 1 day period" in the email
    And I should see "Last transaction:\n  $1.00" in the email
  
  Scenario: I see budget information for day 1, having spent under budget
    Given it is day 1
    And it is midnight
    And today I have spent $49.00
    When the background job runs
    And I open the email
    Then I should see "You can spend $1.00 today" in the email
    And I should see "If you only spend $49.00 today, you will have" in the email
    And I should see "  $50.03 to spend each day" in the email
    And I should see "  $350.24 to spend each week" in the email
    And I should see "  $1451.00 to spend over the next 29 days" in the email
    And I should see "You have saved $1.00 more than expected for a 1 day period" in the email
    And I should see "Last transaction:\n  $-49.00" in the email
  
  Scenario: I see budget information for day 1, having spent exactly my budget
    Given it is day 1
    And it is midnight
    And today I have spent $50.00
    When the background job runs
    And I open the email
    Then I should see "You have spent your budget for today" in the email
    And I should see "If you only spend $50.00 today, you will have" in the email
    And I should see "  $50.00 to spend each day" in the email
    And I should see "  $350.00 to spend each week" in the email
    And I should see "  $1450.00 to spend over the next 29 days" in the email
    And I should see "You have spent exactly as expected for a 1 day period" in the email
    And I should see "Last transaction:\n  $-50.00" in the email
  
  Scenario: I see budget information for day 1, having spent over budget
    Given it is day 1
    And it is midnight
    And today I have spent $51.00
    When the background job runs
    And I open the email
    Then I should see "You have spent your budget for today, plus an additional $1.00" in the email
    And I should see "If you only spend $51.00 today, you will have" in the email
    And I should see "  $49.97 to spend each day" in the email
    And I should see "  $349.76 to spend each week" in the email
    And I should see "  $1449.00 to spend over the next 29 days" in the email
    And I should see "You have spent $1.00 more than expected for a 1 day period" in the email
    And I should see "Last transaction:\n  $-51.00" in the email
    
  Scenario: I see budget information for day 1, having spent all of my spending money
    Given it is day 1
    And it is midnight
    And today I have spent $1500.00
    When the background job runs
    And I open the email
    Then I should see "You should not spend any money for the next 29 days if you want to continue to save $1000.00" in the email
      # total left = 1000
    And I should see "If you wish to spend into your savings this month, you can afford to spend" in the email
    And I should see "  $34.48 each day" in the email
      # total left / days left = 34.48
    And I should see "  $241.38 each week" in the email
      # total left / days left * 7 = 241.38
    And I should see "  $1000.00 over the next 29 days" in the email
    And I should see "You have spent $1450.00 more than expected for a 1 day period" in the email
    And I should see "Last transaction:\n  $-1500.00" in the email
  
  Scenario: I see budget information for day 1, having spent all of my savings
    Given it is day 1
    And it is midnight
    And today I have spent $2500.00
    When the background job runs
    And I open the email
    Then I should see "You should not spend any money for the next 29 days if you want to avoid going into debt" in the email
    And I should see "You have spent $2450.00 more than expected for a 1 day period" in the email
    And I should see "Last transaction:\n  $-2500.00" in the email
  
  Scenario: I see budget information for day 1, having gone into debt
    Given it is day 1
    And it is midnight
    And today I have spent $2501.00
    When the background job runs
    And I open the email
    Then I should see "You need to earn $0.03 today" in the email
      # total left = -1
      # total left / days left including today * -1 = 0.03
    And I should see "Continue to do so for the next 29 days to avoid going into debt" in the email
    And I should see "If you do not, Sum will temporarily decrease your spending money for next month to account for the debt" in the email
    And I should see "You have spent $2451.00 more than expected for a 1 day period" in the email
    And I should see "Last transaction:\n  $-2501.00" in the email
  
  # Day 30

  Scenario: I see budget information for day 30, having spent nothing today
    Given it is day 30
    And it is midnight
    And before today I spent $1450.00
    When the background job runs
    And I open the email
    And I should see "You can spend $50.00 today" in the email
    And I should see "You have saved $50.00 more than expected for a 30 day period" in the email
  
  Scenario: I see budget information for day 30, having deposited money
    Given it is day 30
    And it is midnight
    And I have deposited $1.00
    And before today I spent $1450.00
    When the background job runs
    And I open the email
    Then I should see "You can spend $51.00 today" in the email
    And I should see "You have saved $51.00 more than expected for a 30 day period" in the email
    And I should see "Last transaction:\n  $1.00" in the email
  
  Scenario: I see budget information for day 30, having spent under budget
    Given it is day 30
    And it is midnight
    And before today I spent $1450.00
    And today I have spent $49.00
    When the background job runs
    And I open the email
    Then I should see "You can spend $1.00 today" in the email
    And I should see "You have saved $1.00 more than expected for a 30 day period" in the email
    And I should see "Last transaction:\n  $-49.00" in the email
  
  Scenario: I see budget information for day 30, having spent exactly my budget
    Given it is day 30
    And it is midnight
    And before today I spent $1450.00
    And today I have spent $50.00
    When the background job runs
    And I open the email
    Then I should see "You should not spend any money if you want to continue to save $1000.00" in the email
    And I should see "You have spent exactly as expected for a 30 day period" in the email
    And I should see "Last transaction:\n  $-50.00" in the email
  
  Scenario: I see budget information for day 30, having spent over budget
    Given it is day 30
    And it is midnight
    And before today I spent $1450.00
    And today I have spent $51.00
    When the background job runs
    And I open the email
    Then I should see "You should not spend any money if you want to continue to save $999.00" in the email
    And I should see "You have spent $1.00 more than expected for a 30 day period" in the email
    And I should see "Last transaction:\n  $-51.00" in the email
  
  Scenario: I see budget information for day 30, having spent all of my savings
    Given it is day 30
    And it is midnight
    And before today I spent $1450.00
    And today I have spent $1050.00
    When the background job runs
    And I open the email
    Then I should see "You should not spend any money if you want to avoid going into debt" in the email
    And I should see "You have spent $1000.00 more than expected for a 30 day period" in the email
    And I should see "Last transaction:\n  $-1050.00" in the email
  
  Scenario: I see budget information for day 30, having gone into debt
    Given it is day 30
    And it is midnight
    And before today I spent $1450.00
    And today I have spent $1051.00
    When the background job runs
    And I open the email
    Then I should see "You need to earn $1.00 today" in the email
    And I should not see "Continue to do so" in the email
    And I should see "If you do not, Sum will temporarily decrease your spending money for next month to account for the debt" in the email
    And I should see "You have spent $1001.00 more than expected for a 30 day period" in the email
    And I should see "Last transaction:\n  $-1051.00" in the email