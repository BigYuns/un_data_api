##Technologies
<strong>Database:</strong> MongoDB<br>
<strong>Framework:</strong> Rails 4<br>
<strong>Dependencies:</strong> [Rails-API gem](https://github.com/rails-api/rails-api)<br>
<strong>Testing:</strong> Rspec and Cucumber<br>
<strong>ORM:</strong> [MongoMapper](www.mongomapper.com "MongoMapper")<br>

###Getting Started
1. Fork the repo
2. Clone your fork of un_data_api to your local computer
3. bundle install
4. Get Mongo running
5. Open up another tab in your terminal and change into the un_data_api directory

```
$ git clone https://github.com/username/un_data_api.git
$ cd un_data_api
$ bundle install
$ mongod

# open up another terminal window
$ cd un_data_api
$ rake db:create
$ rake xml_parser:seed_db
```
###Setting up with 3scale
Currently the UN Data API has the plugin implemented into the code already.  It only takes a few steps and you'll be up and running with authentication! In order to use 3scale you need to signup and retrieve the keys you need to use your API.

1. Go to www.3scale.net
2. Click on the big orange button "SIGNUP NOW-FREE!"
3. Sign up!
4. Go to your admin portal and log in. https://your-api-name-admin.3scale.net .
5. Set up your environment variables for development.

#####Enviroment Variables
**Remember the enviroment variables and keys are secret.  Make sure that your .gitignore is configured properly so your keys do not end up on github.  Here is a good article on how to implement environment variables. http://railsapps.github.io/rails-environment-variables.html
im
You can look at the example local environment yaml file to see how to format your file. 
```yml
# config/examples/local_env.yml
PROVIDER_KEY: 'some_provider_key'
APP_ID: 'some_app_id'
APP_KEY: 'some_app_key'
```
#####Active Docs
***You will not be able to use this feature until you deploy into production.
Lucky for you, I have already written and saved the file that generates the active docs. Here are 3scale's docs for Active Docs https://support.3scale.net/howtos/api-configuration#ConfigureActiveDocs .

1. Go to your admin portal.
2. Click on "API"
3. Click on "Active Docs"
4. Click "Create a new spec"
5. Give the spec a name and system_name
6. Get the spec. The only thing you will need to change is the "basePath" to the base url of your project. Go to un_data_active_doc_spec.json 

```json
{
  "basePath": "http://your-api.org/",
  "apiVersion": "v1",
  "apis": [
    {
```
7. You will have to click "publish" if you want them to show up on your Developer Portal.

###Set up without 3scale
If you would like to remove authentication you just need to remove or comment out the following methods from the Application Controller
#####Remove :authenticate_app from the before_filter

```ruby
before_filter :authenticate_app, :default_format_json, :set_access_control_headers
```
#####Remove create_client

```ruby
def create_client
  @@threescale_client ||= ThreeScale::Client.new(:provider_key => ENV['PROVIDER_KEY'])    
end
```

#####Remove authenticate_app

```ruby
def authenticate_app
  response = create_client.authrep(:app_id => params["app_id"], 
                                   :app_key => params["app_key"],
                                   :usage => { params[:metric].to_sym => 1 })
  response_success(response)
end
```

#####Remove response_success(response)

```ruby
def response_success(response)
  if response.success?
    return true
  else
    error(response.error_code, 401, response.error_message)
  end
end
```

###Deploy on Heroku
set your heroku config variables
provider_key
app_id
app_key

  
##Backup your database on Heroku

If you deploy on heroku the project already has the [heroku-mongo-backup gem](http://rubydoc.info/gems/heroku-mongo-backup/0.4.32/frames) installed. 

```
heroku config:add S3_BACKUPS_BUCKET=_value_ S3_KEY_ID=_value_ S3_SECRET_KEY=_value_ MONGO_URL=_value_
```

Example command to back up the database...

```
heroku run rake mongo:backup
```

##XML Parser Documentation
###How to add new databases
####Example Database: World Development Indicators
Go to http://data.un.org/Explorer.aspx and pick a database that you would like to import. For the purposes of this example we are going to use the database World Development Indicators and go throught the steps of how I added this database. The first two items you will need to take note of are the **database name** and the **organization name**.

- **Organization Name:** "World Bank"
- **Organization Acronym** "WB"
- **Full Database Name:** "World Development Indicators"

![Image](https://github.com/3scale/un_data_api/raw/master/public/images/data-un-name-screenshot.png)

Next you will have to download all of the datasets that are under the database. Your file structure should match how the files are listed on that data.un.org website. In “lib/un_data_xml_files/” you will create a directory that is called the acronym of the organzation that the database belongs to. There are multiple databases in an organization so you should check if the directory already exists for the organization. Within the organzation's directory you will create a new directory named the full name of the new database. You will then download all the datasets and save them under this directory.

![Image](https://github.com/3scale/un_data_api/raw/master/public/images/file_structure.png)

1. Next to the dataset click "view data". When you click through each dataset you should take note if they have footnotes. 
![Image](https://github.com/3scale/un_data_api/raw/master/public/images/view_data.png)

2. Click on download and then a box will pop up with the different options to download the dataset.  
![Image](https://github.com/3scale/un_data_api/raw/master/public/images/click_download.png)

3. Select the XML option.  
![Image](https://github.com/3scale/un_data_api/raw/master/public/images/download_xml.png)

4. When the file downloads it will be in a zip format and the file name is a random name assigned by the data.un.org site.  
![Image](https://github.com/3scale/un_data_api/raw/master/public/images/dataset_zip.png)

5. You will have to unzip the file.  
![Image](https://github.com/3scale/un_data_api/raw/master/public/images/dataset-unzipped.png)

6. Copy the dataset name from the data.un.org website.  
![Image](https://github.com/3scale/un_data_api/raw/master/public/images/dataset_name.png)

7. Rename the dataset file to the same as displayed on the website. We try to keep the names exactly the same but sometimes the names have characters that are not supported in filenames.  In that case you will have to replace the character with the appropriate word.  
![Image](https://github.com/3scale/un_data_api/raw/master/public/images/updated_xml_filename.png)


####Step 1: Set Up Rake Tasks
To create the rake tasks that you will use to populate the database you will need a few more pieces of information. 

#####Database Acronym
- Find the name of the database you will be importing. 
- Make sure it is the name of the database and not the name of the organization.
- Get the database acronym
- **Database Acronym:** "wdi"
```
*database_acronym = a lowercase acronym of the database name
```
- Checkout a new branch with parse_ + database_acronym

#####Footnotes
You will need to check if the database has footnotes.
- **Footnote Sequence ID:** "footnoteSeqID"
- If there are no footnotes in the whole database then you will set Footnote Sequence ID to "none"

```xml
<footnote footnoteSeqID="2">Aggregation are calculated using interpolated country level data in the group.</footnote>
```

#####In “lib/tasks/xml_parser.rake” create a new rake task for parsing new database.

```ruby
# With Footnotes
XmlParser.new(Organization Acronym, Full Database Name, Footnote Sequence ID)

# No Footnotes
XmlParser.new(Organization Acronym, Full Database Name, "none")
```

All of the rake tasks that correspond to the parser are nested in the :xml_parser namespace.  The next namespace is the acronym of the organzation. Within the organization's namespace are the tasks that populate the different databases in the organization.

In the tasks below we are creating the tasks that will populate the database.

```ruby
  # :wb corresponds to the organzation's name acronym
  namespace :wb do 
    desc "parse World Development Indicators"
    # wdi is the database acronym
    task wdi: :environment do
      WdiXmlParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end

    desc "tests the country names for wdi"
    # checks the country names in the database
    task wdi_test_countries: :environment do
      TestCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end

    desc "seeds the country names for wdi"
    # seeds ONLY the country names in the database
    task wdi_seed_countries: :environment do
      SeedCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end
  end
```

####Step 3:
In “lib/modules/”
  Create a new file named acronym of database_acronym + _xml_parser
  class database_acronym(Capitalize first letter) +XmlParser < XmlParser
  end

```ruby
# wdi_xml_parser.rb
class WdiXmlParser < XmlParser
end
```
Include the file into the lib/tasks/xml_parser.rake file.

```ruby
# lib/tasks/xml_parser.rake
require "#{Rails.root}/lib/modules/wdi_xml_parser.rb"
```

####Step 4: Normalize Country Names
Between all of the different major organizations there are differences in the way the country names are stored.  When parsing all of the datasets it made it difficult to associate the country names.  Our goal is not to munipulate the data but to make it more easily accessible to developers.  We solved this buy making the parser normalize the country names to make sure there are no duplicates.  

If you look at the main xml_parser in "lib/modules/xml_parser.rb" the normalize_country_name method is a list of the country names that we normalized.  To make sure it is known what the original country name was in the original database we stored the string "area_name" as an attribute on the record to make sure there was no confusion on which country the record belonged to.

- Make sure your database is seeded with all the country names in your DB so far. You can do this by running... It may take a while to finish this process.

```ruby
rake xml_parser:all_countries:names
```
I suggest making a copy of the DB in this stage because you will have to reseed the DB after this step.

```ruby
# You will have a copy of the database with just the country names populated.
mongodump -h localhost:27017 -d un_data_api_development -o ~/un-data-db-copies/all_countries  
```
- Run the database through the country name checker. When you run this method it will be checking the countries without the normalize_country_names method. We want to identify all the countries for this database that need to be normalized.

- This method will print out the names in the terminal that need to be normalized in this database. **SCREEN SHOT**

```ruby
rake xml_parser:wb:wdi_test_countries
```

- The list of all normalized countries is in the “xml_parser.rb” in the normalize_country_names method. Check if any of the countries that are printed out match up with these and build a custom normalize_country_names in the subclass with only the ones needed for that database.  This is to make sure when you parse the database it will cut out some time. **SCREEN SHOT**

**NOTE** When the country name is ran through the normalizer if there is Rep. or Dem. it will be changed to Republic or Democratic.

```ruby
  def un_abrev_country_name(country_name)
    case country_name
    when /Rep\./
      country_name.gsub!(/(Rep\.)/, "Republic")
    when /Dem\./
      country_name.gsub!(/(Dem\.)/, "Democratic")
    end
    normalize_country_name(country_name)
  end
```

#####Example normalize_country_name method

```ruby
def normalize_country_name(country_name)

    case country_name
    when /United States/
      @country_name = "United States of America"
    when /Bolivia/
      @country_name = "Bolivia (Plurinational State of)"
    when /Libya/
      @country_name = "Libya Republic of Jamahiriya"
    when /Macedonia/
      @country_name = "The former Yugoslav Republic of Macedonia"
    when /Korea/
      if country_name.include?("Democratic")
        @country_name = "Democratic People's Republic of Korea"
        set_country
      else
        @country_name = "Republic of Korea"
        set_country
      end
      # There are more to this list this is just an example.
   end
   set_country
end
```
- You might have to add new "normalizations" to the main normalize_country_names method in "xml_parser.rb". Make sure you add it to the main parser class and the database's subclass.

- After you are confident that you have identified all the duplicates and added the necessary changes you will need to clear out your database again and restore it to copy we made earlier before we added the new countries. 

```ruby
# You will have a copy of the database with just the country names populated.
mongodump -h localhost:27017 -d un_data_api_development -o ~/un-data-db-copies/all_countries  
```
After this is finished you will now run the command that will run the countries through the normalizer. This method will also print out any new countries that are being created. The only countries that should be printed out at this point are brand new countries to the database.**SCREEN SHOT**?

You may have to go through this process of seeding the db and restoring it with the copy until you have gotten all the countries.

```ruby
rake xml_parser:wb:wdi_seed_countries
```
####Step 5: Identify Record Attributes
#####Record Attributes

#####Example record from a World Development Indicator dataset.
```xml
<record>
    <field name="Country or Area">Sudan</field>
    <field name="Year">2011</field>
    <field name="Value">81003277106.7864</field>
    <field name="Value Footnotes">2</field>
</record>
```

The record_attribute method is a case statement that does the actual parsing of the XML. This method matches up the record attribute names with the required record attritbutes in the database. 

#####This is a list of the required attributes of a Record.

```ruby
  key :year, Integer
  key :value, Float
  key :measurement, String
  belongs_to :dataset
  belongs_to :country
  key :area_name, String
```
First you will have to match up the attritbutes with the record_attributes method in the main parser, "xml_parser.rb"

```ruby
# /lib/modules/xml_parser.rb
def record_attributes
  @doc.elements.each("ROOT/data/record") do |record|
    record.elements.each do |element|
      element_name = element.attributes["name"]

      case element_name
      when "Country or Area"
        @original_country_name = element.text.strip
        @country_name = @original_country_name
        un_abrev_country_name(@country_name)
      when "Year"
        year = element.text.to_i
        set_year(year)
      when "Year(s)"
        year = element.text.to_i
        set_year(year)
      when "Unit"
        measurement = element.text
        if measurement == "%"
          measurement = "percent"
        end
        set_record("measurement", measurement)
      when "Value"
        value = element.text.to_f
        set_record("value", value)
      when "GENDER"
        gender = element.text
        set_record("gender", gender)
      when "Value Footnotes" 
        if element.text != nil 
          clean_footnotes(element.text)
        end
      else
        name = element_name.downcase.gsub("/ /", "_")
        set_record(name, element.text)
      end
    end
    new_record = Record.new(@record)
    new_record.save
  end
end
```
#####Customized record_attributes method
Since not all the attributes that are required for a record are specified in the xml record you will have to create a "custom" record_attributes method in the subclass to override the super class.

```ruby
# lib/modules/wdi_xml_parser.rb
def record_attributes
  @doc.elements.each("ROOT/data/record") do |record|
    record.elements.each do |element|
      element_name = element.attributes["name"]

      case element_name
      when "Country or Area"
        @original_country_name = element.text.strip
        @country_name = @original_country_name
        normalize_country_name(@country_name)
      when "Year"
        year = element.text.to_i
        set_year(year)
      when "Value"
        value = element.text.to_f
        set_record("value", value)
      when "Value Footnotes" 
        if element.text != nil 
          clean_footnotes(element.text)
        end
      else
      #This section adds the extra attritbutes as attributes to the record
        name = element_name.downcase.gsub("/ /", "_")
        set_record(name, element.text)
      end
    end
    # The measurement for this database is in the title of the dataset. The set_record function adds the attritbutes to the @record hash.
    set_record("measurement", @measurement)    
    new_record = Record.new(@record)
    new_record.save
  end
end
```

#####Footnotes
If you fill in the Footnote Sequence ID the parser will do the rest of the work for you. Just make sure your record attributes method contains the "Value Footnotes" in the case statement. This will call the clean_footnotes method will match up the footnotes with the appropriate record.

```ruby
      when "Value Footnotes" 
        if element.text != nil 
          clean_footnotes(element.text)
        end
```

#####Unit of Measurement
Making sure that each record's measurement attribute is one of the most difficult part of the parsing.  Some datasets have the measurement specified on the record as "Unit", "Unit of Measurement", etc...

```xml
<record>
    <field name="Country or Area">Andorra</field>
    <field name="Year">2006</field>
    <field name="Value">935.5</field>
    <field name="Value Footnotes"></field>
    <field name="Unit">tonnes</field>
</record>
```

Some of the datasets have the measurement specified in the name of the dataset. 

  "Adolescent fertility rate (births per 1,000 women ages 15-19).xml"
  
In this case you will need to use some regex to retrieve the measurement from the dataset name. You will need to write a method to retrieve the name and set it equal to the @measurement instance variable. Then you will pass @ measurement intot the set_record(attribute_name, attribute_value) method. Refer to the record_attributes example above from the "lib/modules/wdi_xml_parser.rb" file.

```ruby
    set_record("measurement", @measurement) 
```

To keep going with our World Development Indicators example we will need to override another method to retrieve the measurement from the dataset name. In the WdiXmlParser we will be adding to the get_dataset_name function. We want to inherit the normal behavior of the method and then add to it. 

```ruby
  def get_dataset_name(filename)
    super
    @measurement = @dataset_name[/\(([^)]+)\)/]
    @measurement.gsub!(/\%/, "percent")
    @measurement.delete!("(")
    @measurement.delete!(")")
  end
```
