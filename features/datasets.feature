Feature: Get all datasets that belong to an organization
	In order to get all the datasets
	A request should be sent

	Scenario: Gets all datasets
		Given I send JSON 
		Given the following organizations:	
			| name |
 			| WHO  |
 		When I send a GET request to "/organization/datasets"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Dataset