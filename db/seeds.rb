# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "rexml/document"
include REXML

def xml_parser(file, organization_name, category_name, measurement)

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
			record = Record.create(year: year, category_id: Category.last.id, country_id: record_country.id, measurement: measurement, value: 0)
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

	xml_parser("un_data_xml_files/Children_aged_<5_years_stunted_for_age_percent.xml", "WHO", "Children Aged <5 Years Stunted for Age", "percent")
	xml_parser("un_data_xml_files/children_aged_<5_years_underweight_for_age_percent.xml", "WHO", "Children Aged <5 Years Underweight for Age", "percent")
	xml_parser("un_data_xml_files/deaths_due_to_tuberculosis_among_HIV-negative_people_per_100_000.xml", "WHO", "Deaths Due To Tuberculosis Among HIV-negative People", "per 100,000")
	xml_parser("un_data_xml_files/deaths_due_to_tuberculosis_among_HIV-positive_people_per_100_000.xml", "WHO", "Deaths Due to Tuberculosis Among HIV-positive People", "per 100,000")
	xml_parser("un_data_xml_files/Incidence_of_tuberculosis_per_year_per_100_000.xml", "WHO", "Incidence of Tuberculosis per Year", "per 100,000")
	xml_parser("un_data_xml_files/Median_availability_of_selected_generic_medicines_percent.xml", "WHO", "Median Availability of Selected Generic Medicines", "percent")
	xml_parser("un_data_xml_files/prevalence_of_condom_use_by_adults_at_higher_risk_sex_15-49_percent.xml", "WHO", "Prevalence of Condom Use by Adults at Higher Risk Sex 15-49", "percent")
	xml_parser("un_data_xml_files/prevalence_of_HIV_among_adults_aged_>=5_years_per_100_000.xml", "WHO", "Prevalence of HIV Among Adults Aged >=5 Years", "per 100,000")
	xml_parser("un_data_xml_files/prevalence_of_tuberculosis_per_100_000.xml", "WHO", "Prevalence of Tuberculosis per 100,000", "per 100,000")
	xml_parser("un_data_xml_files/Tuberculosis_detection_rate_under_DOTS_percent.xml", "WHO", "Tuberculosis Detection Rate Under DOTS", "percent")
	xml_parser("un_data_xml_files/median_consumer_price_ratio_of_selected_generic_medicines_ratio.xml", "WHO", "Median Consumer Price Ratio of Selected Generic Medicines", "ratio")
