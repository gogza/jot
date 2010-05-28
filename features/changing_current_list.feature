Feature: Changing the current list
  As an editor
  I want to change the current list
  So that I can work on the one I want

  Background:
    Given I want to output to a string
    And I have a configuration file containing:
     | email          | api        | proxy          |
     | joe@bloggs.com | ABC1234567 | CheckvistProxy |
    And I have an existing list with:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot knows "Garden tasks" is the current list

  Scenario: changing to another list using exact name
    When I ask to make "House tasks" the current list
    Then jot should display the following lists:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot should mark the "House tasks" as current 
    And jot should not mark the "Garden tasks" as current
    And the jot workspace should have the "House tasks" list marked as current

  Scenario: changing to another list using regular expression
    When I ask to make "^House" the current list
    Then jot should display the following lists:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot should mark the "House tasks" as current 
    And jot should not mark the "Garden tasks" as current
    And the jot workspace should have the "House tasks" list marked as current

  Scenario: editor tries to change to list that doesn't exist
    When I ask to make "Work tasks" the current list
    Then jot should display the following lists:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot should display a message saying "Sorry, Jot can't find a matching list"
    And jot should mark the "Garden tasks" as current 
    And jot should not mark the "House tasks" as current
    And the jot workspace should have the "Garden tasks" list marked as current

  Scenario: editor tries to change to list but the input matches more than one list
    When I ask to make "task" the current list
    Then jot should display the following lists:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot should display a message saying "Hold on! Jot found more than one matching list"
    And jot should mark the "Garden tasks" as current 
    And jot should not mark the "House tasks" as current
    And the jot workspace should have the "Garden tasks" list marked as current


