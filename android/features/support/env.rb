require 'calabash-android/cucumber'
require 'httparty'
require 'rspec/expectations'
require 'active_record'
require 'pickle/world'
require 'pry-nav'

require_relative 'test_constants.rb'
require_relative 'test_state.rb'
require_relative 'test_helpers.rb'

#it is necessary to connect to a database before any of the scenarios run in order to be able to use pickle

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => TestConstants.dummy_event_db_for_pickle_initial_connection)

World do
  TestState.new
end

World(TestHelpers)
