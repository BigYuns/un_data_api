require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"

# Environment Statistics Database
class EsdXmlParser < XmlParser
  def normalize_country_name(country_name)

    if country_name.include? 'United States'
      @country_name = "United States of America"
    elsif country_name.include? 'Bolivia'
      @country_name = "Bolivia (Plurinational State of)"
    elsif country_name.include? 'Macedonia'
      @country_name = "The former Yugoslav Republic of Macedonia"
    elsif country_name.include? 'Korea'
      if country_name.include?("Democratic")
        @country_name = "Democratic People's Republic of Korea"
        set_country
      else
        @country_name = "Republic of Korea"
        set_country
      end
    elsif country_name.include? 'd\'Ivoire'
      @country_name = "Côte d'Ivoire"
    elsif country_name.include? 'Hong Kong SAR'
      @country_name = "Hong Kong SAR, China"
    elsif country_name.include? 'Macao SAR'
      @country_name = "Macao SAR, China"
    elsif country_name.include? 'Grenadines'
      @country_name = "Saint Vincent and the Grenadines"
    end
    set_country
  end
end