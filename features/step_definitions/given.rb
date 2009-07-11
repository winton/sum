Given /^I have created an account$/ do
  $db.migrate_reset
  When "I visit the front page"
  When "I submit a valid form"
end

Given /^I have not created an account$/ do
  $db.migrate_reset
end

Given /^it is midnight$/ do
  now = Time.now.utc
  tonight_at_12 = DateTime.strptime(
    (now + 1.day).strftime("%m/%d/%Y 12:00 AM %Z"),
    "%m/%d/%Y %I:%M %p %Z"
  ).to_time
  Time.stub!(:now).and_return(tonight_at_12)
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
  Time.stub!(:now).and_return(user.reset_at - 1.month + day.days - 2.days)
end

Given /^today I have spent \$(.+)$/ do |amount|
  find_user.spend!(amount)
end

Given /^before today I spent \$(.+)$/ do |amount|
  user = find_user
  user.spent_this_month += amount.to_f
  user.save
end

Given /^I have deposited \$(.+)$/ do |amount|
  find_user.spend!("-#{amount}")
end