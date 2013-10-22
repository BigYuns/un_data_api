# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "rexml/document"
include REXML

def xml_parser(file, organization_name, category_name)

	@organization = Organization.find_or_create_by_name(organization_name)
	@category = Category.find_or_create_by_name(category_name)
	@organization.categories << @category
	@category.organization = @organization

	doc = Document.new File.new(file)
	doc.elements.each("ROOT/data/record/field") do |element|

		if element.attributes["name"] == "Country or Area"
			@country_name = element.text
			country = Country.find_or_create_by_name(@country_name)
			country.organizations << @organization
			if country.categories.include?(@category)
				country.save
			else
			  country.categories << @category
			  country.save
			end
			@category.countries << country
			@category.save
		elsif element.attributes["name"] == "Year(s)"
			year = element.text.to_i
			record_country = Country.find_by_name(@country_name)
			record = Record.create(year: year, category_id: Category.last.id, country_id: record_country.id, measurement: "percent", value: 0)
		elsif element.attributes["name"] == "Value"
			record = Record.last
			value = element.text.to_f
			record.set(value: value)
		elsif element.attributes["name"] == "GENDER"
			record = Record.last
			gender = element.text
			record.set(gender: gender)
			record.save
		end	
	end
end

xml_parser("life_expectancy.xml", "WHO", "Life Expectancy from Birth")
xml_parser("gov_tot_expenditure_perc_health.xml", "WHO", "General Government expenditure on health as a percentage of total government expenditure")
xml_parser("number_of_physicians.xml", "WHO", "Number of Physicians")
xml_parser("population_by_thousands.xml", "WHO", "Population by Thousands")
xml_parser("physicians_per_ten_thousand.xml", "WHO", "Physicians per Ten Thousand")
