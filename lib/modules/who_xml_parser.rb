require "#{Rails.root}/lib/modules/xml_parser.rb"

class WhoXmlParser < XmlParser

  def set_year(year)
    @record = { year: year, 
                dataset_id: @dataset_id, 
                country_id: @country.id,
                area_name: @original_country_name,
                measurement: "none"
              }
  end

  def get_file_names(directory_name)
    file_name_array(directory_name)
  end

  def un_abrev_country_name(country_name)
    normalize_country_name(country_name)
  end

  def normalize_country_name(country_name)
    set_country
  end

end