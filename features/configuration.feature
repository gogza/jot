Feature: Viewer wants to set up jot
  As a viewer
  I want to configure jot
  So that I can connect to jot and get my lists

  Background:
    Given I have to mock up a proxy for Checkvist

  @wip
  Scenario: I want to see my current configuration
    Given I have a configuration file containing:
     | email          | api     |
     | joe@bloggs.com | 1234567 |
    When I ask to see the configuration
    Then jot should display the following:
     | displayed             |
     | email: joe@bloggs.com |
     | api: 1234567          |

