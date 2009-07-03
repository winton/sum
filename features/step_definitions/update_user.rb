When /^submits a valid form with "([^\"]*)"$/ do |input|
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

When /^submits an invalid "([^\"]*)".*$/ do |field|
  fill_all_with_valid_data
  fill_in "user[#{field}]", :with => "invalid"
  click_button
end

When /^submits an empty "([^\"]*)".*$/ do |field|
  fill_all_with_valid_data
  fill_in "user[#{field}]", :with => ""
  click_button
end

Then /^they should see a success page$/ do
  assert_contain "Success!"
end

Then /^the "([^\"]*)" field should have an error$/ do |field|
  assert_have_selector "#user_#{field}"
  assert_have_selector ".validation"
end

Then /^the error should be "([^\"]*)"$/ do |error|
  within ".validation" do
    assert_contain error
  end
end

def fill_all_with_valid_data
  valid = {
    'savings' => '0',
    'income' => '0',
    'bills' => '0',
    'email' => 'cucumber@sumapp.com'
  }
  valid.each do |key, value|
    fill_in "user[#{key}]", :with => value
  end
end
