@sync
Feature: Sync
    The client should do the right thing when syncing data down from the server, even if the server is being retarded.

  # the objects that had good json formatting persist correctly, as expected
  # the objects with bad json formatting do not and do not have any affect on the objects with good json.

  Scenario:
    Given I'm on the Event Directory
    And we are working with dataset A and an event with oid SI4MxlzJjZ
    And the sync server will use recipe sync_malformed_json_sync_objects_1
    When I navigate to the Event Guide
    And the client finishes syncing
    Then the following activities should exist:
      | oid         | name                      |
      | TUUH8K8x4H  | Integration Testing 101   |

    And a map should not exist with name: "this should not get synced due to janky json formatting on the map object"
    And an organization should not exist with organization_name: "Organization with bad json formatting"
    And the following people should exist:
      | oid         | display_name | organization_name | bio                | created_at              |
      | QLFFFLfcea  | Tyler Powers | CrowdCompass      | clever testing guy | 2013-04-29 01:54:01.260 |




  Scenario:
    Given I'm on the Event Directory
    And we are working with dataset A and an event with oid SI4MxlzJjZ
    And the sync server will use recipe sync_malformed_json_sync_objects_1
    When I navigate to the Event Guide
    And the client finishes syncing
    Then the following activities should exist:
      | oid         | name                      |
      | TUUH8K8x4H  | Integration Testing 101   |

    And a map should not exist with name: "this should not get synced due to janky json formatting on the map object"
    And an organization should not exist with organization_name: "Organization with bad json formatting"
    And the following people should exist:
      | oid         | display_name | organization_name | bio                | created_at              |
      | QLFFFLfcea  | Tyler Powers | CrowdCompass      | clever testing guy | 2013-04-29 01:54:01.260 |

  # The client takes the 2nd of the two objects, not caring what the updated_at date is. 
  # If you reverse the order of the objects coming down in the response, the other updated_at will be persisted.

  Scenario:
    Given I'm on the Event Directory
    And we are working with dataset A and an event with oid SI4MxlzJjZ
    And the sync server will use recipe sync_two_duplicate_activity_objects_with_diff_updated_at_dates
    When I navigate to the Event Guide
    And the client finishes syncing
    Then the following activities should exist:
      | oid         | name                   | updated_at              | activity_description                  |
      | DUPLICATED  | schizophrenic activity | 2013-04-28 10:53:46.345 | two activity json objects from server |
    And an activity should not exist with updated_at: "2013-04-30 11:53:46.345"



  # testing good server behavior; syncing a valid location object and ensuring it exists

  Scenario:
    Given I'm on the Event Directory
    And we are working with dataset A and an event with oid SI4MxlzJjZ
    And the sync server will use recipe sync_one_location_object
    When I navigate to the Event Guide
    And the client finishes syncing
    Then a location should exist with name: "The location object testing hut"


  # as expected, the sync process ignores the poorly formed json and the sync tables all stay the same

  Scenario:
    Given I'm on the Event Directory
    And we are working with dataset A and an event with oid SI4MxlzJjZ
    And the sync server will use recipe sync_malformed_json_sync_aggregate
    When I navigate to the Event Guide
    And the client finishes syncing
    Then the client database will not have changed


  # on iOS if we sync down an extra field, the column gets added to the table automagically with SQLPo. Not the case in android - it is ignored (probably the better behavior)

  Scenario:
    Given I'm on the Event Directory
    And we are working with dataset A and an event with oid SI4MxlzJjZ
    And the sync server will use recipe sync_update_existing_activity_with_extra_fields
    When I navigate to the Event Guide
    And the client finishes syncing
    Then the following activities should exist:
      | oid         | name     | activity_description           |
      | iSO3nS79KD  | Event 29 | Updated activity description   |
    And the activities table should not have a column named extra_extra
