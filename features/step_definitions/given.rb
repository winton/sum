Given /^I have created an account$/ do
  $db.migrate_reset
  When "I visit the front page"
  When "I submit a valid form"
end

Given /^I have not created an account$/ do
  User.delete_all
  UserEmail.delete_all
end

Given /^it is midnight$/ do
  now = Time.now.utc
  today_at_12 = DateTime.strptime(
    now.strftime("%m/%d/%Y 12:00 AM %Z"),
    "%m/%d/%Y %I:%M %p %Z"
  ).to_time
  Time.stub!(:now).and_return(today_at_12)
end

Given /^I have created an account with these attributes:$/ do |table|
  $db.migrate_reset
  When "I visit the front page"
  fill_all_with_valid_data(table.hashes.first)
  click_button
end

Given /^today is (.+)$/ do |date|
  now = DateTime.strptime(
    "#{date} #{Time.now.utc.strftime("%H:%M:%S %Z")}",
    "%B %d, %Y %H:%M:%S %Z"
  ).to_time
  Time.stub!(:now).and_return(now)
end

Given /^it is day (.+)$/ do |day|
  day = day.to_i
  user = find_user
  # Email already sent today
  user.update_attribute(:send_at, user.send_at + day.days)
  Time.stub!(:now).and_return(user.reset_at - 1.month + (day - 1).days)
end

Given /^today I have spent \$(.+)$/ do |amount|
  IncomingMail.receive(generate_email(:subject => amount))
end

Given /^before today I spent \$(.+)$/ do |amount|
  user = find_user
  user.spent_this_month += amount.to_f
  user.save
end

Given /^I have deposited \$(.+)$/ do |amount|
  IncomingMail.receive(generate_email(:subject => "+#{amount}"))
end

Given /^the background job ran$/ do
  When "the background job runs"
end