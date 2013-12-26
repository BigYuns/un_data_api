Feature: Get all databases
  In order to get all the databases
  A request should be sent

  Background:
    Given the WHO USA Health and Environment Statistics Database data exists

  Scenario: Gets all databases in JSON
    When I ask for JSON
    When I send a GET request to "/WHO/databases"

    Then the response status should be "200"
    And the response body should be a JSON representation of the Database

  Scenario: Gets all databases in xml
    When I ask for XML
    When I send a GET request to "/WHO/databases?format=xml"

    Then the response status should be "200"
    And the response body should be a xml representation of the Database
