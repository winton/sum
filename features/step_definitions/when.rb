When /^I visit the front page$/ do
  visit '/'
end

When /^I submit a valid form$/ do
  fill_all_with_valid_data
  click_button
end

When /^I submit a valid form with (.+)$/ do |input|
  fill_all_with_valid_data
  values = case input
  when "decimals":     [ "1000.00", "5000.00", "2000.00" ]
  when "numbers only": [ "1000", "5000", "2000" ]
  when "dollar signs": [ "$1000.00", "$5000.00", "$2000.00" ]
  end
  fill_in "user[savings]", :with => values.pop
  fill_in "user[income]", :with => values.pop
  fill_in "user[bills]", :with => values.pop
  click_button
end

When /^submit an invalid (.+)$/ do |field|
  fill_all_with_valid_data
  fill_in "user[#{field.split.first}]", :with => "invalid"
  click_button
end

When /^submit an empty (.+)$/ do |field|
  fill_all_with_valid_data
  fill_in "user[#{field.split.first}]", :with => ""
  click_button
end

When /^the background job runs$/ do
  visit '/cron'
end

When /^output the email$/ do
  puts current_email.body
end