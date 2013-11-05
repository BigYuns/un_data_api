Feature: Get all records
  In order to retrieve all records
  A request should be sent

  Scenario: Get all records
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
 		Given the following records:
 			| year | value | gender |
 			| 2001 |    30 | Female |
 			
 		When I send a GET request to "/organization/dataset/country/records"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Record