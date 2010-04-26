Feature: Viewer wants to see their lists
  As a viewer
  I want to see my lists
  So that I can choose one to work on

  Scenario: viewing multiple lists
    Given I have to mock up a proxy for Checkvist
    And I have an existing list called "Garden tasks" list
    And I have an existing list called "House tasks" list
    And jot knows "Garden tasks" is the current list
    When I ask to see the lists
    Then jot should show the "Garden tasks" list
    And jot should show the "House tasks" list
    And jot should mark the "Garden tasks" as current 
    And jot should not mark the "House tasks" as current  

  Scenario: viewing a single list
    Given I have to mock up a proxy for Checkvist
    And I have an existing list called "Garden tasks" list
    When I ask to see the lists
    Then jot should show the "Garden tasks" list
    And jot should mark the "Garden tasks" as current

  Scenario: viewing multiple lists when a current list is not set
    Given I have to mock up a proxy for Checkvist
    And I have an existing list called "Garden tasks" list
    And I have an existing list called "House tasks" list
    And none of the lists are marked as current
    When I ask to see the lists
    Then jot should show the "Garden tasks" list
    And jot should show the "House tasks" list
    And jot should mark the one of the lists as current
    And the jot workspace should have one list marked as current




