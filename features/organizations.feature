Feature: Get all organizations
	In order to get all the organizations
	A request should be sent

	Scenario: Gets all organizations in JSON
		Given I send JSON
		Given the following organizations:
		  | name |
		  | WHO  |
		When I send a GET request to "/organizations.json"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Organization

	Scenario: Gets all organizations in xml
		Given I send xml
		Given the following organizations:
		  | name |
		  | WHO  |
		When I send a GET request to "/organizations.xml"
		Then the response status should be "200"
		And the response body should be a xml representation of the Organization


