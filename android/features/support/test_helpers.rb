module TestHelpers

  def pull_event_db_from_device(event_oid)
    
    local_database_path = "#{TestConstants.files_from_device_directory}/databases/#{event_oid}.sqlite3"
    remote_database_path = "#{TestConstants.device_cc_data_directory}/databases/#{event_oid}/#{event_oid}.sqlite3"

    retriable :tries => 5000, :interval => 1 do
      puts "Attempting to pull database from device..."
      
      pull(remote_database_path, local_database_path)
      raise "Event database file not found on the device" if not File.exist?(local_database_path)
    end
  end


  def connect_to_current_event_db
    
    ActiveRecord::Base.clear_active_connections!

    if !self.device_event_db_has_been_pulled_once
      pull_event_db_from_device(self.current_event_oid)
      self.device_event_db_has_been_pulled_once = true
    end

    local_database_path = "#{TestConstants.files_from_device_directory}/databases/#{self.current_event_oid}.sqlite3"
        
    puts "Connecting to database at path: #{local_database_path}"

    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => local_database_path)

  end


  def compare_databases(dataset, event_oid)

    local_device_database_path = "#{TestConstants.files_from_device_directory}/databases/#{event_oid}.sqlite3"
    comparison_database_path = "#{TestConstants.databases_for_device_directory}/dataset_#{dataset}/#{event_oid}.sqlite3"

    if !self.device_event_db_has_been_pulled_once
      pull_event_db_from_device(event_oid)
      self.device_event_db_has_been_pulled_once = true
    end

    all_tables_the_same = true

    device_db = SQLite3::Database.new(local_device_database_path)
    comparison_db = SQLite3::Database.new(comparison_database_path)

    device_db.results_as_hash = true
    comparison_db.results_as_hash = true
    
    puts "Comparing all sync tables between the original database and the one we pulled from the device"

    TestConstants.sync_tables.each do |table|
      
      device_db_rows = device_db.execute("SELECT * FROM #{table}")
      comparison_db_rows = comparison_db.execute("SELECT * FROM #{table}")

      current_table_rows_the_same = device_db_rows == comparison_db_rows

      puts "Compared table: #{table}, same?: #{current_table_rows_the_same}"
      
      if !current_table_rows_the_same
        all_tables_the_same = false
      end
    end

    raise "The databases contain different data in the sync tables!" if not all_tables_the_same

    puts "Are all tables the same?: #{all_tables_the_same}"
  end

end
