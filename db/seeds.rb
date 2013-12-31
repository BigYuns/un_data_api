require "rexml/document"
include REXML

def gender?(doc)
  doc.root.elements['data'].elements['record'].elements.each do |field|
    if field.attributes['name'] == "GENDER"
      return true
      break
    end
  end
  false
end

def xml_parser(file, organization_name, dataset_name, measurement)

  @organization = Organization.find_by_name(organization_name)
  @dataset = Dataset.find_by_name(dataset_name)
  @dataset_id = @dataset.id

  doc = Document.new File.new(file)
  doc.elements.each("ROOT/footnotes/footnote") do |footnote|
    number = footnote.attributes["footnoteSeqID"]
    text = footnote.text
    footnote = Footnote.create(number: number.to_i, dataset_id: @dataset.id, text: text)
  end

  if gender?(doc)
  	doc.elements.each("ROOT/data/record/field") do |element|
	    if element.attributes["name"] == "Country or Area"
	      @country_name = element.text.strip
	      @country = Country.find_by_name(@country_name)
	    elsif element.attributes["name"] == "Year(s)"
	      @year = element.text.to_i
	    elsif element.attributes["name"] == "Value"
	      @value = element.text.to_f
	    elsif element.attributes["name"] == "GENDER"
	      @gender = element.text
	    elsif element.attributes["name"] == "Value Footnotes" && element.text != nil && !element.text.include?(",")
	    	record = Record.find_by_country_id_and_dataset_id_and_year_and_value_and_gender(@country.id, @dataset_id, @year, @value, @gender)
	      footnote_number = element.text
	      footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first 
	      record.footnotes << footnote
	      record.save
	    elsif element.attributes["name"] == "Value Footnotes" && element.text != nil && element.text.include?(",")
	    	record = Record.find_by_country_id_and_dataset_id_and_year_and_value_and_gender(@country.id, @dataset_id, @year, @value, @gender)
	      footnote_numbers = element2.text.split(",")
	      footnote_numbers.each do |footnote_number|
	        footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first
	        record.footnotes << footnote
	        record.save
	      end
	    end 
	  end
  else
  	doc.elements.each("ROOT/data/record/field") do |element|
	    if element.attributes["name"] == "Country or Area"
	      @country_name = element.text.strip
	      @country = Country.find_by_name(@country_name)
	    elsif element.attributes["name"] == "Year(s)"
	      @year = element.text.to_i
	    elsif element.attributes["name"] == "Value"
	      @value = element.text.to_f
	    elsif element.attributes["name"] == "Value Footnotes" && element.text != nil && !element.text.include?(",")
	      record = Record.find_by_country_id_and_dataset_id_and_year_and_value(@country.id, @dataset_id, @year, @value)
	      footnote_number = element.text
	      footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first
	      record.footnotes << footnote
	      record.save
	    elsif element.attributes["name"] == "Value Footnotes" && element.text != nil && element.text.include?(",")
	    	record = Record.find_by_country_id_and_dataset_id_and_year_and_value(@country.id, @dataset_id, @year, @value)
	      footnote_numbers = element.text.split(",")
	      footnote_numbers.each do |footnote_number|
	        footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first
	        record.footnote << footnote
	        record.save
	      end
	    end
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
	xml_parser("un_data_xml_files/plague_number_of_reported_cases_number.xml", "WHO", "Plague Number of Reported Cases", "count")
	xml_parser("un_data_xml_files/neonates_protected_at_birth_against_neonatal_tetanus_PAB_percent.xml", "WHO", "Neonates Protected at Birth Against Neonatal Tetanus (PAB)", "percent")
	xml_parser("un_data_xml_files/neonatal_tetanus_number_of_reported_cases_number.xml", "WHO", "Neonatal Tetanus - Number of Reported Cases", "count")
	xml_parser("un_data_xml_files/neonatal_mortaility_rate_per_1000_live_births.xml", "WHO", "Neonatal Mortality Rate per 1000 Live Births", "count")
	xml_parser("un_data_xml_files/mumps_number_of_reported_cases_number.xml", "WHO", "Mumps - Number of Reported Cases", "count")
	xml_parser("un_data_xml_files/meningitis_number_of_reported_cases_number.xml", "WHO", "Meningitis - Number of Reported Cases", "count")
	xml_parser("un_data_xml_files/yellow_fever_number_of_reported_cases_number.xml", "WHO", "Yellow Fever - Number of Reported Cases", "count")
	xml_parser("un_data_xml_files/tuberculosis_number_of_reported_cases_number.xml", "WHO", "Tuberculosis - Nnumber of Repored Cases", "count")
	xml_parser("un_data_xml_files/total_tetanus_number_of_reported_cases_number.xml", "WHO", "Total Tetanus - Number of Reported Cases", "count")
	xml_parser("un_data_xml_files/total_fertility_rate_per_woman.xml", "WHO", "Total Fertility Rate", "per woman")
	xml_parser("un_data_xml_files/total_expenditure_on_health_as_a_percentage_of_gross_domestic_product_percent.xml", "WHO", "Total Expenditure on Health as a percentage of Gross Domestic Product", "percent")
	xml_parser("un_data_xml_files/social_security_expenditure_on_health_as_a_percentage_of_general_government_expenditure_on_health.xml", "WHO", "Social security expenditure on health as a percentage of general government expenditure on health", "percent")
	xml_parser("un_data_xml_files/rubella_number_reported_cases_number.xml", "WHO", "Rubella - Number of reported cases", "count")
	xml_parser("un_data_xml_files/proportion_of_population_using_improved_sanitation_facilities_percent.xml", "WHO", "Proportion of population using improved sanitation facilities", "percent")	
	xml_parser("un_data_xml_files/proportion_of_population_using_improved_drinking-water_sources_percent.xml", "WHO", "Proportion of population using improved drinking-water sources", "percent")
	xml_parser("un_data_xml_files/private_prepaid_plans_as_a_percentage_of_private_expenditure_on_health_percent.xml", "WHO", "Private prepaid plans as a percentage of private expenditure on health", "percent")
	xml_parser("un_data_xml_files/private_expenditure_on_health_as_a_percentage_of_total_expenditure_on_health_percent.xml", "WHO", "Private expenditure on health as a percentage of total expenditure on health", "percent")
	xml_parser("un_data_xml_files/prevalence_of_current_tobacco_use_among_adults_>||=15_years_percent.xml", "WHO", "Prevalence of current tobacco use among adults older than 15 years", "percent")
	xml_parser("un_data_xml_files/prevalence_of_current_tobacco_use_among_adolescents_13-15_years_percent.xml", "WHO", "Prevalence of current tobacco use among adolescent 13-15 years old", "percent")
	xml_parser("un_data_xml_files/population_proportion_under_15_percent.xml", "WHO", "Population proportion under 15 years", "percent")
	xml_parser("un_data_xml_files/population_proportion_over_60_percent.xml", "WHO", "Population proportion over 60", "percent")
	xml_parser("un_data_xml_files/population_median_age_years.xml", "WHO", "Population median age", "age")
	xml_parser("un_data_xml_files/population_living_on_<$1_PPP_int_$_a_day_percent.xml", "WHO", "Percentage of population living on less than $1 a day", "percent")
	xml_parser("un_data_xml_files/population_living_in_urban_areas_percent.xml", "WHO", "Percentage of population living in urban areas", "percent")
	xml_parser("un_data_xml_files/population_thousands_total.xml", "WHO", "Population in thousands", "thousands")
	xml_parser("un_data_xml_files/poliomyelitis_number_of_reported_cases_number.xml", "WHO", "Poliomyelitis - Number of reported cases", "count")
	xml_parser("un_data_xml_files/physicians_density_per_10_000.xml", "WHO", "Physicians density", "per 10,000")
	xml_parser("un_data_xml_files/pertussis_number_of_reported_cases_number.xml", "WHO", "Pertussis - Number of reported cases", "count")
	xml_parser("un_data_xml_files/per_capita_total_expenditure_on_health_at_average_exchange_rate_US.xml", "WHO", "Per capita total expenditure on health at average exchange rate", "US Dollar")
	xml_parser("un_data_xml_files/per_capita_total_expenditure_on_health_PPP_int_$.xml", "WHO", "Per capita total expenditure on health", "PPP int. $")
	xml_parser("un_data_xml_files/per_capita_government_expenditure_on_health_at_average_exchange_rate_US.xml", "WHO", "Per capita government expenditure on health at average exchange rate", "US Dollar")
	xml_parser("un_data_xml_files/per_capita_government_expenditure_on_health_PPP_int_$.xml", "WHO", "Per capita government expenditure on health", "PPP int. $")
	xml_parser("un_data_xml_files/out-of-pocket_expenditure_as_a_percentage_of_private_expenditure_on_health_percent.xml", "WHO", "Out-of-Pocket expenditure as a percentage of private expenditure on health", "percent")
	xml_parser("un_data_xml_files/other_health_service_providers_density_per_10_000.xml", "WHO", "Other health service providers density", "per 10,000")
	xml_parser("un_data_xml_files/nursing_and_midwifery_personnel_density_per_10_000.xml", "WHO", "Nursing and midwifery personnel density", "per 10,000")
	xml_parser("un_data_xml_files/number_of_physicians_number.xml", "WHO", "Number of physicians", "count")
	xml_parser("un_data_xml_files/number_of_other_health_service_providers_number.xml", "WHO", "Number of other health service providers", "count")
	xml_parser("un_data_xml_files/number_of_nursing_and_midwifery_personnel_number.xml", "WHO", "Number of nursing and midwifery personnel", "count")
	xml_parser("un_data_xml_files/number_of_dentistry_personnel_number.xml", "WHO", "Number of dentistry personnel", "count")
	xml_parser("un_data_xml_files/number_of_community_health_workers_number.xml", "WHO", "Number of community health workers", "count")
	xml_parser("un_data_xml_files/net_primary_school_enrollment_ratio_percent.xml", "WHO", "Net primary school enrollment ratio", "percent")
	xml_parser("un_data_xml_files/median_consumer_price_ratio_of_selected_generic_medicines_private_ratio.xml", "WHO", "Median consumer price ratio of selected generic medicines private", "ratio")
	xml_parser("un_data_xml_files/median_availability_of_selected_generic_medicines_private_percent.xml", "WHO", "Median availability of selected generic medicines private", "percent")
	xml_parser("un_data_xml_files/measles_MCV_immunization_coverage_among_1-year-olds_percent.xml", "WHO", "Measles MCV immunization coverage among 1-year-olds", "percent")
	xml_parser("un_data_xml_files/measles_number_of_reported_cases_number.xml", "WHO", "Measles - Number of reported cases", "count")
	xml_parser("un_data_xml_files/malaria_number_of_reported_cases_number.xml", "WHO", "Malaria - Number of reported cases", "count")
	xml_parser("un_data_xml_files/low_birth_weight_newborns_percent.xml", "WHO", "Low birth weight newborns", "percent")
	xml_parser("un_data_xml_files/life_expectancy_at_birth_years.xml", "WHO", "Life expectancy at birth", "years")
	xml_parser("un_data_xml_files/leprosy_number_of_reported_cases_number.xml", "WHO", "Leprosy - Number of reported cases", "count")
	xml_parser("un_data_xml_files/japanese_encephalitis_number_of_reported_cases_number.xml", "WHO", "Japanese encephalitis - Number of reported cases", "count")
	xml_parser("un_data_xml_files/infants_exclusively_breastfed_for_the_first_six_months_of_life_percent.xml", "WHO", "Infants exclusively breastfed for the first 6-months of life", "percent")
	xml_parser("un_data_xml_files/hospital_beds_per_10_000.xml", "WHO", "Number of hospital beds", "per 10,000")
	xml_parser("un_data_xml_files/hib_Hib3_immunization_coverage_among_1-year-olds_percent.xml", "WHO", "Hib Hib3 immunization coverage among 1-year-olds", "percent")
	xml_parser("un_data_xml_files/hepatitis_B_HepB3_immunization_coverage_among_1-year-olds_percent.xml", "WHO", "Hepatitis B HepB3 immunization coverage among 1-year-olds", "percent")
	xml_parser("un_data_xml_files/healthy_life_expectancy_HALE_at_birth_years.xml", "WHO", "Healthy life expectancy HALE at birth", "years")
	xml_parser("un_data_xml_files/H5N1_influenza_number_of_recorded_cases_number.xml", "WHO", "H5N1 influenza - Number of reported cases", "count")
	xml_parser("un_data_xml_files/gross_national_income_per_capita_PPP_int_$.xml", "WHO", "Gross national income per capita", "PPP int. $")
	xml_parser("un_data_xml_files/general_government_expenditure_on_health_as_a_percentage_of_total_government_expenditure_percent.xml", "WHO", "General government expenditure on health as a percentage of total government expenditure", "percent") 
	xml_parser("un_data_xml_files/general_government_expenditure_on_health_as_a_percentage_of_total_expenditure_on_health_percent.xml", "WHO", "General government expenditure on health as a percentage of total expenditure on health", "percent") 
	xml_parser("un_data_xml_files/external_resources_for_health_as_a_percentage_of_total_expenditure_on_health_percent.xml", "WHO", "External resources for health as a percentage of total health expenditure", "percent")
	xml_parser("un_data_xml_files/distribution_of_years_of_life_lost_by_broader_causes_noncommunicable_percent.xml", "WHO", "Distribution of years of life lost by broader causes - noncommunicable", "percent")
	xml_parser("un_data_xml_files/distribution_of_years_of_life_lost_by_broader_causes_injuries_percent.xml", "WHO", "Distribution of years of life lost by broader causes - injuries", "percent")
	xml_parser("un_data_xml_files/distribution_of_years_of_life_lost_by_broader_causes_communicable_percent.xml", "WHO", "Distribution of years of life lost by broader causes - communicable", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_pneumonia_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - pneumonia", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_other_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - other", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_neonatal_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - neonatal", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_measles_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - measles", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_malaria_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - malaria", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_injuries_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - injuries", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_HIV-AIDS_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - HIV/AIDS", "percent")
	xml_parser("un_data_xml_files/distributions_of_causes_of_death_among_children_aged_<5_years_diarrhoea_percent.xml", "WHO", "Distribution of causes of death among children aged <5 years - diarrhoea", "percent")	
	xml_parser("un_data_xml_files/diphtheria_tetanus_toxoid_and_pertussis-DTP3_immunizations_coverage_among_1-year-olds_percent.xml", "WHO", "Diphtheria tetanus toxoid and pertussis-DTP3 immunizations covereage among 1-year-olds", "percent")
	xml_parser("un_data_xml_files/diphtheria_number_of_reported_cases_number.xml", "WHO", "Diphtheria - Number of reported cases", "count")
	xml_parser("un_data_xml_files/dentistry_personnel_density_per_10_000.xml", "WHO", "Dentistry personnel density", "per 10,000")
	xml_parser("un_data_xml_files/deaths_due_to_HIV-AIDS_per_100_000.xml", "WHO", "Deaths due to HIV/AIDS", "per 100,000")
	xml_parser("un_data_xml_files/congenital_rubella_syndrome-number_of_reported_cases_number.xml", "WHO", "Congenital rubella syndrome - Number of reported cases", "count")
	xml_parser("un_data_xml_files/community_health_workers_density_per_10_000.xml", "WHO", "Community health workers density", "per 10,000")
	xml_parser("un_data_xml_files/civil_registration_coverage_of_deaths_percent.xml", "WHO", "Civil registration coverage of deaths", "percent")
	xml_parser("un_data_xml_files/civil_registration_coverage_of_births_percent.xml", "WHO", "Civil registration coverage of births", "percent")
	xml_parser("un_data_xml_files/cholera- number_of_reported_cases_number.xml", "WHO", "Cholera - Number of reported cases", "count")
	xml_parser("un_data_xml_files/children_aged_6-59_months_who_received_vitamin_A_supplementation_percent.xml", "WHO", "Children aged 6-59 months who received vitamin A supplementation", "percent")
	xml_parser("un_data_xml_files/children_aged_<5_years_with_diarrhoea_receiving_ORT_percent.xml", "WHO", "Children aged <5 years with diarrhoea receiving ORT", "percent")
	xml_parser("un_data_xml_files/children_aged_<5_years_with_ARI_symptoms_taken_to_facility_percent.xml", "WHO", "Children aged <5 with ARI symtoms taken to facility", "percent")
	xml_parser("un_data_xml_files/children_aged_<5_years_overweight_for_age_percent.xml", "WHO", " Children aged <5 overweight for age", "percent")
	xml_parser("un_data_xml_files/births_by_caesarean_section_percent.xml", "WHO", "Births by caesarean section", "percent")
	xml_parser("un_data_xml_files/antiretroviral_therapy_coverage_among_HIV-infected_pregant_women_for_PMTCT_percent.xml", "WHO", "Antiretroviral therapy coverage among HIV-infected pregnant women for PMTCT", "percent")
	xml_parser("un_data_xml_files/antenatal_care_coverage_at_least_one_visit_percent.xml", "WHO", "Antenatal care coverage at least one visit", "percent")
	xml_parser("un_data_xml_files/antenatal_care_coverage_at_least_four_visits_percent.xml", "WHO", "Antenatal care coverage at least four visits", "percent")
	xml_parser("un_data_xml_files/annual_population_growth_rate_percent.xml", "WHO", "Annual population growth rate", "percent")
	xml_parser("un_data_xml_files/alcohol_consumption_amount_adults_>||=15_years_liters_of_pure_alcohol_per_year.xml", "WHO", "Alcohol consumption amount adults 15 years or older", "liters of pure alcohol per year")
	xml_parser("un_data_xml_files/age-standardized_mortality_rate_cause_noncommunicable_per_100_000.xml", "WHO", "Age-standardized mortality rate cause - noncommunicable", "per 100,000")
	xml_parser("un_data_xml_files/age-standardized_mortality_rate_cause_injuries_per_100_000.xml", "WHO", "Age-standardized mortality rate cause - injuries", "per 100,000")
	xml_parser("un_data_xml_files/age-standardized_mortality_rate_cause_cardiovascular_per_100_000.xml", "WHO", "Age-standardized mortality rate cause - cardiovascular", "per 100,000")
	xml_parser("un_data_xml_files/age-standardized_mortality_rate_cause_cancer_per_100_000.xml", "WHO", "Age-standardized mortality rate cause - cancer", "per 100,000")
	xml_parser("un_data_xml_files/adults_aged_<||=15_years_who_are_obese_percent.xml", "WHO", "Adults 15 years or older who are obese", "percent") 
	xml_parser("un_data_xml_files/adult_15-60_mortality_rate_per_1000.xml", "WHO", "Adult 15-60 years mortality rate", "per 1,000")
	xml_parser("un_data_xml_files/adult_literacy_rate_percent.xml", "WHO", "Adult literacy rate", "percent")

