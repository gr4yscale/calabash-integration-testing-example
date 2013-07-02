$:.unshift File.dirname __FILE__
require 'wait_for_activity'

Given /^I'm on the (.+) activity$/ do |activity|
  wait_for_activity activity
end

When /^I touch the settings button$/ do
    touch("imageButton id:'cc_title_bar_button_home'")
end


When /^I press the directory button$/ do
    touch("Button id:'cc_ed_directory_tab'")
end

Then /^I should see "([^\"]*)" in the event directory list$/ do |text|
    wait_for_elements_exist( ["com.crowdcompass.view.StyledTextView text:'#{text}'"], :timeout => 4)
end

Then /^I touch "([^\"]*)" in the event directory list$/ do |text|
    touch("com.crowdcompass.view.StyledTextView text:'#{text}'")
end

Then /^I should see "([^\"]*)" in the my events list$/ do |text|
    wait_for_elements_exist( ["com.crowdcompass.view.StyledTextView text:'#{text}'"], :timeout => 4)
end


When /^I touch "([^\"]*)" in the my events list$/ do |text|
    touch("com.crowdcompass.view.StyledTextView text:'#{text}'")
end


When /^I touch the launch button with text "([^\"]*)"$/ do |text|

    touch(text)
end

When /^I touch the list item with text "([^\"]*)"$/ do |text|

  touch("com.crowdcompass.view.StyledTextView text:'#{text}'")
end
