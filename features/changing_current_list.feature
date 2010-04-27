Feature: Changing the current list
  As a viewer
  I want to change the current list
  So that I can work on the one I want

  Background:
    Given I have to mock up a proxy for Checkvist

  Scenario: viewing multiple lists
    Given I have an existing list with:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot knows "Garden tasks" is the current list
    When I ask to make "House tasks" the current list
    Then jot should display the following lists:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot should mark the "House tasks" as current 
    And jot should not mark the "Garden tasks" as current
    And the jot workspace should have the "House tasks" list marked as current


