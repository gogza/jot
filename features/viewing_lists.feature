Feature: Viewer wants to see their lists
  As a viewer
  I want to see my lists
  So that I can choose one to work on

  Background:
    Given I want to output to a string
    And I have a configuration file containing:
     | email     | api        | proxy          |
     | joebloggs | ABC1234567 | CheckvistProxy |

  Scenario: viewing multiple lists
    Given Checkvist has the existing lists:
     | name         | id |
     | Garden tasks | 12 |
     | House tasks  | 13 |
    And jot knows "Garden tasks" is the current list
    When I ask to see the lists
    Then jot should display the following lists:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot should mark the "Garden tasks" as current 
    And jot should not mark the "House tasks" as current  

  Scenario: viewing a single list
    Given Checkvist has the existing lists:
     | name         | id |
     | Garden tasks | 12 |
    When I ask to see the lists
    Then jot should show the "Garden tasks" list
    And jot should mark the "Garden tasks" as current

  Scenario: viewing multiple lists when a current list is not set
    Given Checkvist has the existing lists:
     | name         | id |
     | Garden tasks | 12 |
     | House tasks  | 13 |
    And none of the lists are marked as current
    When I ask to see the lists
    Then jot should display the following lists:
     | name         |
     | Garden tasks |
     | House tasks  |
    And jot should mark the one of the lists as current
    And the jot workspace should have one list marked as current


