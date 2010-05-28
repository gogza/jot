Feature: Viewer wants to set up jot
  As a viewer
  I want to configure jot
  So that I can connect to jot and get my lists

  Background:
    Given I want to output to a string
    And I have a configuration file containing:
     | email          | api        | proxy          |
     | joe@bloggs.com | ABC1234567 | CheckvistProxy |

  @config
  Scenario: I want to see my configuration file
    Then the configuration file should contain the following:
     | value              |
     | joe@bloggs.com |
     | ABC1234567     |
     | CheckvistProxy |  

  @config
  Scenario: I want to see my current configuration
    When I ask to see the configuration
    Then jot should display the following:
     | displayed             |
     | email: joe@bloggs.com |
     | api: ABC1234567       |
     | proxy: CheckvistProxy |

  @config
  Scenario: I want to change my current configuration
    When I ask to change the configuration to:
     | email          | api        |
     | ben@bloggs.com | XYZ1234567 |
    Then the configuration file should contain the following:
     | value          |
     | ben@bloggs.com |
     | XYZ1234567     |  

