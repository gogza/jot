Feature: Viewer wants to set up jot
  As a viewer
  I want to configure jot
  So that I can connect to jot and get my lists

  Background:
    Given I have to mock up a proxy for Checkvist

  @wip @config
  Scenario: I want to see my configuration file
    Given I have a configuration file containing:
     | email          | api        | proxy              |
     | joe@bloggs.com | ABC1234567 | CheckvistProxyMock |
    Then the configuration file should contain the following:
     | value              |
     | joe@bloggs.com     |
     | ABC1234567         |
     | CheckvistProxyMock |  

  @wip @config
  Scenario: I want to see my current configuration
    Given I have a configuration file containing:
     | email          | api        | proxy              |
     | joe@bloggs.com | ABC1234567 | CheckvistProxyMock |
    When I ask to see the configuration
    Then jot should display the following:
     | displayed                 |
     | email: joe@bloggs.com     |
     | api: ABC1234567           |
     | proxy: CheckvistProxyMock |

  @wip @config
  Scenario: I want to change my current configuration
    Given I have a configuration file containing:
     | email          | api        |
     | joe@bloggs.com | ABC1234567 |
    When I ask to change the configuration to:
     | email          | api        |
     | ben@bloggs.com | XYZ1234567 |
    Then the configuration file should contain the following:
     | value          |
     | ben@bloggs.com |
     | XYZ1234567     |  

