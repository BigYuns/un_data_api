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
end