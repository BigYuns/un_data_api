Feature: Get all countries that are in the dataset
  In order to retrieve all countries
  A request should be sent

	Scenario: Get all countries
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
 		When I send a GET request to "/organization/dataset/countries"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Country