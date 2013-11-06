Feature: Get all records
  In order to retrieve all records
  A request should be sent

  Scenario: Get all records in JSON
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
 			
 		When I send a GET request to "/organization/dataset/country/records.json"
		Then the response status should be "200"
		And the response body should be a JSON representation of the Record

		Scenario: Get all records in xml
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
	 		Given the following records:
	 			| year | value | gender |
	 			| 2001 |    30 | Female |
	 			
	 		When I send a GET request to "/organization/dataset/country/records.xml"
			Then the response status should be "200"
			And the response body should be a xml representation of the Record