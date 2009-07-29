Then /^I should see a form$/ do
  assert_have_selector "form[action='/new'][method='post']"
end

Then /^I should see a.? (.+) text field$/ do |field|
  assert_have_selector "#user_#{field}"
end

Then /^I should see a.? (.+) checkbox$/ do |field|
  assert_have_selector "#user_#{field}"
end

Then /^I should see a submit button$/ do
  assert_have_selector "input[type=image]"
end

Then /^I should see a success page$/ do
  within "h1" do
    assert_contain "Success!"
  end
end

Then /^the (.+) field should have an error$/ do |field|
  assert_have_selector "#user_#{field}"
  assert_have_selector ".validation"
end

Then /^the error should be "([^\"]*)"$/ do |error|
  within ".validation" do
    assert_contain error
  end
end

Then /^spent today should be zero$/ do
  find_user.spent_today.should == 0
end