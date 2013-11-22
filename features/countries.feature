Feature: Get all countries that are in the dataset
  In order to retrieve all countries
  A request should be sent

  Background:
    Given the WHO USA Health data exists

  Scenario: Get all countries in JSON
    When I ask for JSON 
    When I send a GET request to "/WHO/Health/countries"

    Then the response status should be "200"
    And the response body should be a JSON representation of the Country

  Scenario: Get all countries in xml
    When I ask for XML
    When I send a GET request to "/WHO/Health/countries?format=xml"

    Then the response status should be "200"
    And the response body should be a xml representation of the Country