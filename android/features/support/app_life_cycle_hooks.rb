require 'calabash-android/management/adb'
require 'calabash-android/operations'


Before do |scenario|
#  cmd = "adb shell mount -o remount rw /sdcard; rm -r /mnt/sdcard/Android/data/com.crowdcompass.eventshortname/calabash"
#  raise "Could not remove the calabash flag files that indicate when sync starts and stops" unless system(cmd)

  FileUtils.rm_rf(TestConstants.files_from_device_directory)

  Dir.mkdir(TestConstants.files_from_device_directory)
  
  self.device_event_db_has_been_pulled_once = false

  start_test_server_in_background
end

After do |scenario|
  if scenario.failed?
    #screenshot_embed
    #
    #let's not take screenshots when scenarios fail right now; it crashes the test suite and I haven't had a chance to investigate.
  end
  shutdown_test_server
end
