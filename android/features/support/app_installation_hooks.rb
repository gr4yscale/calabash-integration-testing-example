require 'calabash-android/management/app_installation'
require 'pry-nav'

AfterConfiguration do |config|
	FeatureNameMemory.feature_name = nil
end

$first_run = true 

Before do |scenario|
  @scenario_is_outline = (scenario.class == Cucumber::Ast::OutlineTable::ExampleRow)
  if @scenario_is_outline 
    scenario = scenario.scenario_outline 
  end 

  if $first_run
    log "First run - reinstalling apps"
    $first_run = false

#    local_app_database_path = "/Users/gr4yscale/Code/quality/calabash/android/databases_for_device/tumbleweed.sqlite3"
#    remote_app_database_path = "/mnt/sdcard/Android/data/com.crowdcompass.eventshortname/databases/tumbleweed.sqlite3"
    
#    puts "before installing app: pushing app database from local path: #{local_app_database_path} to device at: #{remote_app_database_path}"

#    push(local_app_database_path, remote_app_database_path)

    uninstall_apps 
    install_app(ENV["TEST_APP_PATH"])
    install_app(ENV["APP_PATH"])
  end

  #clear_app_data

  # Ensure that the calabash flag files (used to indicate when async/background operations are complete) are removed before running each scenario

  #binding.pry

  retriable :tries => 5000, :interval => 1 do
    cmd = "adb shell mount -o remount rw /sdcard"
    raise "Could not remount the sd card partition as read-write" unless system(cmd)
  end

  retriable :tries => 5000, :interval => 1 do
    cmd = "adb shell 'rm -r #{TestConstants.device_cc_data_directory}/calabash'"
    raise "Could not remove the calabash flag files that indicate when sync starts and stops" unless system(cmd)
  end

  #binding.pry

  clear_app_data

  
  feature_name = scenario.feature.title
  if FeatureNameMemory.feature_name != feature_name
    FeatureNameMemory.feature_name = feature_name
    FeatureNameMemory.invocation = 1
  else
    FeatureNameMemory.invocation += 1
  end
end

FeatureNameMemory = Class.new
class << FeatureNameMemory
  @feature_name = nil
  attr_accessor :feature_name, :invocation
end
