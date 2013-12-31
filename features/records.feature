Feature: Get all records
  In order to retrieve all records
  A request should be sent

  Background:
    Given the WHO USA Health and Environment Statistics Database data exists

  Scenario: Get all records in JSON
    When I ask for JSON 
    When I send a GET request to "/WHO/Health/USA/records"

    Then the response status should be "200"
    And the response body should be a JSON representation of the Record

  Scenario: Get all records in xml
    When I ask for XML
    When I send a GET request to "/WHO/Health/USA/records?format=xml"

    Then the response status should be "200"
    And the response body should be a xml representation of the Record

  Scenario: Get all records from a country in a database in JSON
    When I ask for JSON 
    When I send a GET request to "/WHO/Environment Statistics Database/Health/USA/records"

    Then the response status should be "200"
    And the response body should be a JSON representation of the Record

  Scenario: Get all records from a country in a database in xml
    When I ask for XML
    When I send a GET request to "/WHO/Environment Statistics Database/Health/USA/records?format=xml"

    Then the response status should be "200"
    And the response body should be a xml representation of the Record