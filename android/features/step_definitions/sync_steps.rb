require 'calabash-android/calabash_steps'
require 'calabash-android/operations'
require 'retriable'
require 'pry-nav'
require 'json'



#Given /^I am not going to sign in$/ do
#    performAction('wait_for_screen', 'AuthenticationController')
#    performAction('wait_for_button', "No thanks, I'll do it later.")
#    performAction('press_button_with_text', "No thanks, I'll do it later.")
#end


Given /^I'm on the Event Directory$/ do
#  performAction('wait_for_button', "OK")
#  performAction('press_button_with_text', "OK")
  performAction('wait_for_screen', 'EventDirectoryController')
end




And /^we are working with dataset (.+) and an event with oid (.+)$/ do |dataset,event_oid|

  self.current_dataset = dataset
  self.current_event_oid = event_oid

  puts "dataset: #{self.current_dataset}, event_oid: #{self.current_event_oid}"

  local_database_path = "#{TestConstants.databases_for_device_directory}/dataset_#{self.current_dataset}/#{self.current_event_oid}.sqlite3"
  remote_database_path = "#{TestConstants.device_cc_data_directory}/databases/#{self.current_event_oid}/#{self.current_event_oid}.sqlite3"

  puts "pushing database from local path: #{local_database_path} to device at: #{remote_database_path}"
  
  push(local_database_path, remote_database_path)

end



And /^the sync server will use recipe (.+)$/ do |recipe|

  puts "sync server recipe:#{recipe}"

  self.current_mock_server_recipe = recipe

  config_param = {"dataset" => self.current_dataset, "recipe" => recipe}

  response = HTTParty.put("http://mocky.crowdcompass.com:80/configure",
                :body => { :config => config_param.to_json})
end



When /^I navigate to the Event Guide$/ do

  performAction('wait_for_text', 'The Next Round Robin')
  touch("com.crowdcompass.view.StyledTextView text:'The Next Round Robin'")
  performAction('wait_for_button', "Open Event")
  performAction('press_button_with_text', "Open Event")
#  performAction('assert_text', "Event Guide", true)
end



And /^the client finishes syncing$/ do

  #binding.pry 

  puts "Waiting for client to finish syncing..."
  
  retriable :tries => 120, :interval => 1 do
    pull("#{TestConstants.device_cc_data_directory}/calabash/calabash_end_sync", "#{TestConstants.files_from_device_directory}/calabash_end_sync")
    raise "calabash_end_sync file not found on the device; sync has not finished" if not File.exist?("#{TestConstants.files_from_device_directory}/calabash_end_sync")
  end
  
  #binding.pry
  puts "Done waiting for sync."
end



Then /^the client database will not have changed$/ do

  compare_databases(self.current_dataset, self.current_event_oid)

end



And /^the (.+) table should not have a column named (.+)$/ do |table_name, column_name|

  connect_to_current_event_db
  raise if ActiveRecord::Base.connection.column_exists?(table_name.to_sym, column_name.to_sym)
end
