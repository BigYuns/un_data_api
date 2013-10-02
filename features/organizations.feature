Feature: Get all organizations
	In order to get all the organizations
	A request should be sent

	Scenario: Gets all organizations
		Given I fill in the url with "localhost:3000/organizations"
		When I send the request
		Then the response should be a json response with organizations