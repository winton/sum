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
    When the background job runs
    And I open the email
    Then I should see "Today's budget" in the subject
    And I should see "Fiscal month: 06/01/09 to 07/01/09 (30 days)" in the email
  
  
  # Day 1
  
  Scenario: I see budget information for day 1, having spent nothing today
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $50.00 today.
      
      If you don't spend anything today, you will have
        $51.72 to spend each day.
        $362.07 to spend each week.
        $1500.00 to spend over the next 29 days.
      
      You have saved $50.00 more than expected for a 1 day period.
      """
      # days in month = 30
      # spending money / days in month = 50
      # days left = 29
      # spending money / days left = 51.72
      # spending money / days left * 7 = 362.07
  
  Scenario: I see budget information for day 1, having deposited money
    Given it is day 1
    And I have deposited $1.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $51.00 today.
      
      If you don't spend anything today, you will have
        $51.76 to spend each day.
        $362.31 to spend each week.
        $1501.00 to spend over the next 29 days.
      
      You have saved $51.00 more than expected for a 1 day period.
      """
      # (spending money / days in month) - spent today = 51
      # spending money + 1 = 1501
  
  Scenario: I see budget information for day 1, having spent under budget
    Given it is day 1
    And today I have spent $49.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $1.00 today.
      
      If you only spend $49.00 today, you will have
        $50.03 to spend each day.
        $350.24 to spend each week.
        $1451.00 to spend over the next 29 days.
      
      You have saved $1.00 more than expected for a 1 day period.
      """
  
  Scenario: I see budget information for day 1, having spent exactly my budget
    Given it is day 1
    And today I have spent $50.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You have spent your budget for today.
      
      If you only spend $50.00 today, you will have
        $50.00 to spend each day.
        $350.00 to spend each week.
        $1450.00 to spend over the next 29 days.
      
      You have spent exactly as expected for a 1 day period.
      """
  
  Scenario: I see budget information for day 1, having spent over budget
    Given it is day 1
    And today I have spent $51.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You have spent your budget for today, plus an additional $1.00.
      
      If you only spend $51.00 today, you will have
        $49.97 to spend each day.
        $349.76 to spend each week.
        $1449.00 to spend over the next 29 days.
      
      You have spent $1.00 more than expected for a 1 day period.
      """
  
  Scenario: I see budget information for day 1, having spent all of my spending money
    Given it is day 1
    And today I have spent $1500.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You should not spend any money for the next 29 days if you want to continue to save $1000.00.
      
      If you wish to spend into your savings this month, you can afford to spend
        $34.48 each day.
        $241.38 each week.
        $1000.00 over the next 29 days.
      
      You have spent $1450.00 more than expected for a 1 day period.
      """
      # total left = 1000
      # total left / days left = 34.48
      # total left / days left * 7 = 241.38
  
  Scenario: I see budget information for day 1, having spent all of my savings
    Given it is day 1
    And today I have spent $2500.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You should not spend any money for the next 29 days if you want to avoid going into debt.
      
      You have spent $2450.00 more than expected for a 1 day period.
      """
  
  Scenario: I see budget information for day 1, having gone into debt
    Given it is day 1
    And today I have spent $2501.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You need to earn $0.03 today.
      
      Continue to do so for the next 29 days to avoid going into debt.
      
      If you do not, Sum will temporarily decrease your spending money for next month to account for the debt.
      
      You have spent $2451.00 more than expected for a 1 day period.
      """
      # total left = -1
      # total left / days left including today * -1 = 0.03

  # Day 15

  Scenario: I see budget information for day 15, having spent nothing today
    Given it is day 15
    And before today I spent $700.00
    And today I have spent $0.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $50.00 today.
      
      If you don't spend anything today, you will have
        $53.33 to spend each day.
        $373.33 to spend each week.
        $800.00 to spend over the next 15 days.
      
      You have saved $50.00 more than expected for a 15 day period.
      """

  Scenario: I see budget information for day 15, having deposited money
    Given it is day 15
    And I have deposited $1.00
    And before today I spent $700.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $51.00 today.
      
      If you don't spend anything today, you will have
        $53.40 to spend each day.
        $373.80 to spend each week.
        $801.00 to spend over the next 15 days.
      
      You have saved $51.00 more than expected for a 15 day period.
      """

  Scenario: I see budget information for day 15, having spent under budget
    Given it is day 15
    And before today I spent $700.00
    And today I have spent $49.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $1.00 today.
      
      If you only spend $49.00 today, you will have
        $50.07 to spend each day.
        $350.47 to spend each week.
        $751.00 to spend over the next 15 days.
      
      You have saved $1.00 more than expected for a 15 day period.
      """

  Scenario: I see budget information for day 15, having spent exactly my budget
    Given it is day 15
    And before today I spent $700.00
    And today I have spent $50.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You have spent your budget for today.
      
      If you only spend $50.00 today, you will have
        $50.00 to spend each day.
        $350.00 to spend each week.
        $750.00 to spend over the next 15 days.
      
      You have spent exactly as expected for a 15 day period.
      """

  Scenario: I see budget information for day 15, having spent over budget
    Given it is day 15
    And before today I spent $700.00
    And today I have spent $51.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You have spent your budget for today, plus an additional $1.00.
      
      If you only spend $51.00 today, you will have
        $49.93 to spend each day.
        $349.53 to spend each week.
        $749.00 to spend over the next 15 days.
      
      You have spent $1.00 more than expected for a 15 day period.
      """
    
  Scenario: I see budget information for day 15, having spent all of my spending money
    Given it is day 15
    And before today I spent $700.00
    And today I have spent $800.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You should not spend any money for the next 15 days if you want to continue to save $1000.00.
      
      If you wish to spend into your savings this month, you can afford to spend
        $66.67 each day.
        $466.67 each week.
        $1000.00 over the next 15 days.
      
      You have spent $750.00 more than expected for a 15 day period.
      """

  Scenario: I see budget information for day 15, having spent all of my savings
    Given it is day 15
    And before today I spent $700.00
    And today I have spent $1050.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You should not spend any money for the next 15 days if you want to continue to save $750.00.
      
      If you wish to spend into your savings this month, you can afford to spend
        $50.00 each day.
        $350.00 each week.
        $750.00 over the next 15 days.
      
      You have spent $1000.00 more than expected for a 15 day period.
      """
  
  Scenario: I see budget information for day 15, having gone into debt
    Given it is day 15
    And before today I spent $700.00
    And today I have spent $1801.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You need to earn $0.06 today.
      
      Continue to do so for the next 15 days to avoid going into debt.
      
      If you do not, Sum will temporarily decrease your spending money for next month to account for the debt.
      
      You have spent $1751.00 more than expected for a 15 day period.
      """

  # Day 30

  Scenario: I see budget information for day 30, having spent nothing today
    Given it is day 30
    And before today I spent $1450.00
    And today I have spent $0.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $50.00 today.
      
      You have saved $50.00 more than expected for a 30 day period.
      """
  
  Scenario: I see budget information for day 30, having deposited money
    Given it is day 30
    And I have deposited $1.00
    And before today I spent $1450.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $51.00 today.
      
      You have saved $51.00 more than expected for a 30 day period.
      """
  
  Scenario: I see budget information for day 30, having spent under budget
    Given it is day 30
    And before today I spent $1450.00
    And today I have spent $49.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You can spend $1.00 today.
      
      You have saved $1.00 more than expected for a 30 day period.
      """
  
  Scenario: I see budget information for day 30, having spent exactly my budget
    Given it is day 30
    And before today I spent $1450.00
    And today I have spent $50.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You should not spend any money if you want to continue to save $1000.00.
      
      You have spent exactly as expected for a 30 day period.
      """
  
  Scenario: I see budget information for day 30, having spent over budget
    Given it is day 30
    And before today I spent $1450.00
    And today I have spent $51.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You should not spend any money if you want to continue to save $999.00.
      
      You have spent $1.00 more than expected for a 30 day period.
      """
  
  Scenario: I see budget information for day 30, having spent all of my savings
    Given it is day 30
    And before today I spent $1450.00
    And today I have spent $1050.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You should not spend any money if you want to avoid going into debt.
      
      You have spent $1000.00 more than expected for a 30 day period.
      """
  
  Scenario: I see budget information for day 30, having gone into debt
    Given it is day 30
    And before today I spent $1450.00
    And today I have spent $1051.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      You need to earn $1.00 today.
      
      If you do not, Sum will temporarily decrease your spending money for next month to account for the debt.
      
      You have spent $1001.00 more than expected for a 30 day period.
      """
  
  
  # Transactions
  
  Scenario: I see my last transaction
    Given today I have spent $1.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      Last transaction:
        $-1.00
      """
  
  Scenario: I see my last two transactions
    Given today I have spent $1.00
    And today I have spent $2.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      Last 2 transactions:
        $-2.00
        $-1.00
      """

  Scenario: I see my last five transactions
    Given today I have spent $1.00
    And today I have spent $2.00
    And today I have spent $3.00
    And today I have spent $4.00
    And today I have spent $5.00
    And today I have spent $6.00
    When the background job runs
    And I open the email
    Then I should see in the email:
      """
      Last 5 transactions:
        $-6.00
        $-5.00
        $-4.00
        $-3.00
        $-2.00
      """