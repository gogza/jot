Feature: Viewer wants to see their lists
  As a viewer
  I want to see my lists
  So that I can choose one to work on

  Scenario: viewing lists
    Given I have to mock up a proxy for Checkvist
    And I have an existing list called "Garden tasks" list
    And I have an existing list called "House tasks" list
    When I ask to see the lists
    Then jot should show the "Garden tasks" list
    And jot should show the "House tasks" list

