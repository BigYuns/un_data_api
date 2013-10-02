Feature: Get all organizations
	In order to get all the organizations
	A request should be sent

	Scenario: Gets all organizations
		Given I fill in the url with "localhost:3000/organizations"
		When the client requests GET /organizations
		Then the response should be a json response with organizations