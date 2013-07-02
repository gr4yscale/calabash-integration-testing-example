module TestConstants
  def self.databases_for_device_directory
    "/Users/gr4yscale/Code/quality/calabash/android/databases_for_device"
  end

  def self.files_from_device_directory
   "/Users/gr4yscale/Code/quality/calabash/android/files_from_device"
  end

  def self.device_cc_data_directory
    "/mnt/sdcard/Android/data/com.crowdcompass.eventshortname"
  end

  def self.dummy_event_db_for_pickle_initial_connection
    "android/misc/dummy_event_db_for_pickle_initial_connection.sqlite3"
  end

  def self.sync_tables
    return ["activities", "assets", "attendee_roles", "attendees", "banners", "bookmarks", "compass_items", "contacts", "custom_list_items", "deleted_items", "entity_roles", "external_links", "launch_items", "list_templates", "locations", "map_settings", "maps", "organizations", "pages", "people", "presenters", "ratings", "related_activities", "reminders", "roles", "schedule_items", "taggings", "tags", "tracks"]
  end
end

