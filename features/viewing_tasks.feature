Feature: Viewer wants to see the tasks on the current lists
  As a viewer
  I want to see the task on the current list
  So that I can remind myself what to do

  Background:
    Given I want to output to a string
    And I have a configuration file containing:
     | email     | api        | proxy          |
     | joebloggs | ABC1234567 | CheckvistProxy |
    And Checkvist has the existing lists:
     | name         | id |
     | Garden tasks | 12 |
     | House tasks  | 13 |
    And jot knows "Garden tasks" is the current list

  @wip
  Scenario: viewing the current list
    Given the current list has the following tasks:
     | content         | id | children | parent |
     | Tidy up         | 20 | 10,11    | 0      |
     | Cut the grass   | 10 |          | 20     |
     | Trim the hedge  | 11 |          | 20     |
    When I ask to see the tasks for the current list
    Then jot should display this phrase "   Tidy up"
    Then jot should display this phrase "     Cut the grass"
    Then jot should display this phrase "     Trim the hedge"

