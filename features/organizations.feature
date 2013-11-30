Feature: Get all organizations
  In order to get all the organizations
  A request should be sent

  Background:
    Given the WHO USA Health data exists

  Scenario: Gets all organizations in JSON
    When I ask for JSON
    When I send a GET request to "/organizations"

    Then the response status should be "200"
    And the response body should be a JSON representation of the Organization

  Scenario: Gets all organizations in xml
    When I ask for XML
    When I send a GET request to "/organizations?format=xml"

    Then the response status should be "200"
    And the response body should be a xml representation of the Organization


