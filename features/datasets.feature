Feature: Get all datasets 
	In order to get all the datasets
	A request should be sent

	Scenario: Gets all datasets that belong to an organization in JSON
		Given I send JSON 
		Given the following organizations:	
			| name |
 			| WHO  |
 		Given the following datasets:
 			| name   | 
 			| Health | 
 		When I send a GET request to "/organization/datasets"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Dataset

	Scenario: Gets all datasets that belong to an organization in xml
		Given I send xml
		Given the following organizations:	
			| name |
 			| WHO  |
 		Given the following datasets:
 			| name   | 
 			| Health | 
 		When I send a GET request to "/organization/datasets?format=xml"
		Then the response status should be "200"
		And the response body should be a xml representation of the Dataset

	Scenario: Gets all datasets that the specified country is in JSON
		Given I send JSON 
		Given the following organizations:	
			| name |
 			| WHO  |
 		Given the following datasets:
 			| name   | 
 			| Health | 
 		Given the following countries:
 			| name | 
 			| USA	 |
 		When I send a GET request to "/organization/country/datasets"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Dataset

	Scenario: Gets all datasets that the specified country is in xml
		Given I send xml
		Given the following organizations:	
			| name |
 			| WHO  |
 		Given the following datasets:
 			| name   | 
 			| Health | 
 		Given the following countries:
 			| name | 
 			| USA	 |
 		When I send a GET request to "/organization/country/datasets?format=xml"
		Then the response status should be "200"
		And the response body should be a xml representation of the Dataset


		