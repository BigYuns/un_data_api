Feature: Get all datasets that belong to an organization
	In order to get all the datasets
	A request should be sent

	Scenario: Gets all datasets in JSON
		Given I send JSON 
		Given the following organizations:	
			| name |
 			| WHO  |
 		When I send a GET request to "/organization/datasets.json"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Dataset

	Scenario: Gets all datasets in xml
		Given I send xml
		Given the following organizations:	
			| name |
 			| WHO  |
 		When I send a GET request to "/organization/datasets.xml"
		Then the response status should be "200"
		And the response body should be a xml representation of the Dataset