# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "rexml/document"
include REXML

def xml_parser(file, organization_name, dataset_name, measurement)

	@organization = Organization.find_or_create_by_name(organization_name)
	@dataset = Dataset.find_or_create_by_name(dataset_name)
	@organization.datasets << @dataset
	@dataset.organization = @organization

	doc = Document.new File.new(file)
	doc.elements.each("ROOT/footnotes/footnote") do |footnote|
		number = footnote.attributes["fnSeqID"]
		text = footnote.text
		footnote = Footnote.create(number: number, dataset_id: @dataset.id, text: text)
		puts footnote.text
	end

	doc.elements.each("ROOT/data/record/field") do |element|

		if element.attributes["name"] == "Country or Area"
			@country_name = element.text.strip
			country = Country.find_or_create_by_name(@country_name)
			country.organizations << @organization
			@organization.countries << country
			@organization.save
			if country.datasets.include?(@dataset)
				country.save
			else
			  country.datasets << @dataset
			  country.save
			end
			@dataset.countries << country
			@dataset.save
		elsif element.attributes["name"] == "Year"
			year = element.text.to_i
			record_country = Country.find_by_name(@country_name)
			record = Record.create(year: year, dataset_id: Dataset.last.id, country_id: record_country.id, measurement: measurement, value: 0)
		elsif element.attributes["name"] == "Value"
			record = Record.last
			value = element.text.to_f
			record.set(value: value)
			record.reload
		elsif element.attributes["name"] == "GENDER"
			record = Record.last
			gender = element.text
			record.set(gender: gender)
			record.reload
		elsif element.attributes["name"] == "Value Footnotes" && element.text != nil && !element.text.include?(",")
			record = Record.last
			footnote_number = element.text
			footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first 
			record.footnotes << footnote
			record.save
		elsif element.attributes["name"] == "Value Footnotes" && element.text != nil && element.text.include?(",")
			record = Record.last
			footnote_numbers = element.text.split(",")
			footnote_numbers.each do |footnote_number|
				footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first
				record.footnotes << footnote
				record.save
			end
		end	
	end
end