Given /^I have created an account$/ do
  $db.migrate_reset
end

Given /^I have not created an account$/ do
  $db.migrate_reset
end
