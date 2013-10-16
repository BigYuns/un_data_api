Feature: Get all organizations
	In order to get all the organizations
	A request should be sent

	Scenario: Gets all organizations
		Given I send JSON
		When I send a GET request to "/organizations"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Organization