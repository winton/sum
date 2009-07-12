Given /^(?:my email queue is empty|no emails have been sent)$/ do
  reset_mailer
end

When /^I open the email$/ do
  open_email(current_email_address)
end
 
When %r{^I follow "([^"]*?)" in the email$} do |link|
  visit_in_email(link)
end
 
Then /^I should receive (an|\d+) emails?$/ do |amount|
  amount = 1 if amount == "an"
  unread_emails_for(current_email_address).size.should == amount.to_i
end
 
Then %r{^"([^"]*?)" should receive (\d+) emails?$} do |address, n|
  unread_emails_for(address).size.should == n.to_i
end
 
Then %r{^"([^"]*?)" should have (\d+) emails?$} do |address, n|
  mailbox_for(address).size.should == n.to_i
end
 
Then %r{^"([^"]*?)" should not receive an email$} do |address|
  find_email(address).should be_nil
end
 
Then %r{^I should see "([^"]*?)" in the subject$} do |text|
  current_email.should have_subject(Regexp.new(Regexp.escape(text).gsub("\\n", "\n")))
end

Then %r{^I should see in the email:$} do |text|
  current_email.body.should =~ Regexp.new(Regexp.escape(text).gsub("\\n", "\n"))
end
 
Then %r{^I should see "([^"]*?)" in the email$} do |text|
  current_email.body.should =~ Regexp.new(Regexp.escape(text).gsub("\\n", "\n"))
end
 
When %r{^"([^"]*?)" opens? the email with subject "([^"]*?)"$} do |address, subject|
  open_email(address, :with_subject => subject)
end
 
When %r{^"([^"]*?)" opens? the email with text "([^"]*?)"$} do |address, text|
  open_email(address, :with_text => text)
end
 
When /^I click the first link in the email$/ do
  click_first_link_in_email
end