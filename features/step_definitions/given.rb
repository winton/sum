Given /^I have created an account$/ do
  $db.migrate_reset
  user = User.create(
    :savings => '0',
    :income => '0',
    :bills => '0',
    :email => 'cucumber@sumapp.com'
  )
  user.send_now = false
  user.save
end

Given /^I have not created an account$/ do
  $db.migrate_reset
end

Given /^it is midnight$/ do
  now = Time.now.utc
  tonight_at_12 = DateTime.strptime(
    (now + 24 * 60 * 60).strftime("%m/%d/%Y 12:00 AM %Z"),
    "%m/%d/%Y %I:%M %p %Z"
  ).to_time
  Time.stub!(:now).and_return(tonight_at_12)
end

Given /^I have created an account with these attributes:$/ do |table|
  user = User.new
  table.hashes.first.each do |key, value|
    user.send("#{key}=", value)
  end
  user.save
end

Given /^it is day (.+)$/ do |day|
  day = day.to_i
  user = User.find_by_email("cucumber@sumapp.com")
  Time.stub!(:now).and_return(user.reset_at - 1.month + day.days)
end