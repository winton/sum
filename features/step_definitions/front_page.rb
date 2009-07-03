When /^a user visits the front page$/ do
  visit '/'
end

Then /^they should see a form$/ do
  assert_have_selector "form[action='/new'][method='post']"
end

Then /^they should see a.? "([^\"]*)" text field$/ do |field|
  assert_have_selector "#user_#{field}"
end

Then /^they should see a submit button$/ do
  assert_have_selector "input[type=image]"
end
