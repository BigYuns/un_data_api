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

xml_parser("un_data_xml_files/Precipitation.xml", "Environment Statistics Database", "Precipitation", "million cubic metres")
xml_parser("un_data_xml_files/actual_evapotranspiration.xml", "Environment Statistics Database", "Actual Evapotranspiration", "million cubic metres")
xml_parser("un_data_xml_files/freshwater_internal_flow.xml", "Environment Statistics Database", "Freshwater internal flow ", "million cubic metres")
xml_parser("un_data_xml_files/inflow_of_surface_and_groundwaters.xml", "Environment Statistics Database", "Inflow of surface and groundwaters", "million cubic metres")
xml_parser("un_data_xml_files/renewable_freshwater_resources.xml", "Environment Statistics Database", "Renewable freshwater resources", "million cubic metres")
xml_parser("un_data_xml_files/gross_freshwater_abstracted.xml", "Environment Statistics Database", "Gross freshwater abstracted", "million cubic metres")
xml_parser("un_data_xml_files/gross_fresh_surface_water_abstracted.xml", "Environment Statistics Database", "Gross fresh surface water abstracted", "million cubic metres")
xml_parser("un_data_xml_files/gross_fresh_groundwater_abstracted.xml", "Environment Statistics Database", "Gross fresh groundwater abstracted", "million cubic metres")
xml_parser("un_data_xml_files/net_freshwater_supplied_by_water_supply_industry.xml", "Environment Statistics Database", "Net freshwater supplied by water supply industry", "million cubic metres")
xml_parser("un_data_xml_files/net_freshwater_supplied_by_water_supply_industry_to_households.xml", "Environment Statistics Database", "Net freshwater supplied by water supply industry to: Households", "million cubic metres")
xml_parser("un_data_xml_files/total_population_supplied_by_water_supply_industry.xml", "Environment Statistics Database", "Total population supplied by water supply industry", "percent")
xml_parser("un_data_xml_files/population_connected_to_wastewater_collecting_system.xml", "Environment Statistics Database", "Population connected to wastewater collecting system", "percent")
xml_parser("un_data_xml_files/population_connected_to_wastewater_treatment.xml", "Environment Statistics Database", "Population connected to wastewater treatment", "percent")
xml_parser("un_data_xml_files/municipal_waste_collected.xml", "Environment Statistics Database", "Municipal waste collected", "1000 tonnes")
xml_parser("un_data_xml_files/total_population_served_by_municipal_waste_collection.xml", "Environment Statistics Database", "Total population served by municipal waste collection", "percent")
xml_parser("un_data_xml_files/hazardous_waste_generated.xml", "Environment Statistics Database", "Hazardous waste generated", "tonnes")