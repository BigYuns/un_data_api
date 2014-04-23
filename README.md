##Technologies
<strong>Database:</strong> MongoDB<br>
<strong>Framework:</strong> Rails 4<br>
<strong>Dependencies:</strong> [Rails-API gem](https://github.com/rails-api/rails-api)<br>
<strong>Testing:</strong> Rspec and Cucumber<br>
<strong>ORM:</strong> [MongoMapper](www.mongomapper.com "MongoMapper")<br>

####All of the documentation is in the wiki - [Check out the wiki!](https://github.com/3scale/un_data_api/wiki)

###Follow these steps from set-up to deployment and beyond!
#####STEP 1: SET UP LOCALLY AND IMPLEMENT 3SCALE - [Getting Started](https://github.com/3scale/un_data_api/wiki/Getting-Started)
#####STEP 2: DEPLOY YOUR APPLICATION ON HEROKU - [Deploy to Heroku](https://github.com/3scale/un_data_api/wiki/Deploy-to-Heroku)
#####STEP 3: GENERATE MORE DATA IN YOUR DATABASE - [Databases Available](https://github.com/3scale/un_data_api/wiki/Databases-Available) - [Rake Tasks](https://github.com/3scale/un_data_api/wiki/Rake-Tasks)
#####STEP 4: ADD YOUR OWN DATABASES - [XML Parser Documentation](https://github.com/3scale/un_data_api/wiki/XML-Parser-Documentation)
#####STEP 5: BACKUP YOUR DATABASE LOCALLY AND IN PRODUCTION - [Backup to Amazon S3](https://github.com/3scale/un_data_api/wiki/Backup-to-Amazon-S3)
#####STEP 6: CHECKOUT ADDITION FEATURES- [Additional Features - More Monitoring - Active Docs](https://github.com/3scale/un_data_api/wiki/Additional-Features)

######[Get Started (Without 3scale)](https://github.com/3scale/un_data_api/wiki/Getting-Started-(Without-3scale))

###What is the UN Data API
####An unofficial API version of the great data made available by the United Nations on the UNDATA site. 

The UN Data site has a large database aggregating data from a multitude of important organizations throughout the world. Some of the organizations include the World Health Organization, the International Telecommunications Union, and the United Nations Statistics Division. The problem is that you could only access the data by downloading the files in XML, CSV, and a few other formats. This leads to the problem that if you want to analyze the data, you have to download all the files and parse them into your own database for analyzation and to display the information. We also ran into the issue that between the different organizations, the country names used were not consistent.

We feel that the data on the UN Data site has great value and should be easily accessible to developers. Also, having all the information normalized by country would eventually make it easier to query between different organization’s databases. Our first goal was to get as much of the data as possible into our database and then make more complex queries available to the user. It was important to us to store the data with the minimal amount of manipulation and duplication.

Since beginning this project the UN Data site has released their own API.
Checkout the official [UNDATA SOAP API](http://data.un.org/Host.aspx?Content=API) using the SDMX standard. 

###Why did we do it?

1. Make data more easily accessible. The UN has a lot of interesting and useful data and we want developers to be able to access it.
2. Provide an example implementation of a RESTful API for learning purposes.
3. Showcase 3SCALE’s easy to use authentication and monitoring solutions.

###The API Design

We decided to go with an intuitive RESTful API design. It is important that the API is as easy to use a possible. The main URI format is Organization/Database/Dataset/Country/Records. It serves JSON as default or you can specify the format as XML if preferred.

The hardest part about the project was normalizing all of the country names. In the end we had to make a decision on how to present all of the country names. Since we correlated all the countries together we also added an attribute to the record that stores the name of the country how it was presented in its original database.

###This is an example of how to implement 3scale to your API.
This API does all of its authentication using 3SCALE'S API Management system. 3SCALE offers services to authenticate, monitor and rate limit your API. We have two main options to implement the API management system. The first are plugins, which is language specific code package that you add to your code directly. The second option is to use a proxy. The UN Data API uses the plugin option.

The MIT License (MIT)
Copyright (c) 2014 3SCALE

