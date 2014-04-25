require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"

# Industrial Commodity Statistics Database
class IcsdXmlParser < XmlParser
  def normalize_country_name(country_name)

    if country_name.include? 'United States'
      @country_name = "United States of America"
    elsif country_name.include? 'Bolivia'
      @country_name = "Bolivia (Plurinational State of)"
    elsif country_name.include? 'Libya'
      @country_name = "Libya"
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
    elsif country_name.include? 'Congo'
      if country_name.include?("Rep") && !country_name.include?("Dem")
        @country_name = "Congo"
      elsif country_name.include?("Dem")
        @country_name = "Democratic Republic of the Congo"
      end
    elsif country_name.include? 'Grenadines'
      @country_name = "Saint Vincent and the Grenadines"
    elsif country_name.include? 'Venezuela'
      @country_name = "Venezuela (Bolivarian Republic of)"
    elsif country_name.include? 'Iran'
      @country_name = "Iran (Islamic Republic of)"
    elsif country_name.include? 'Lao'
      @country_name =  "Lao People's Democratic Republic"
    elsif country_name.include? 'Micronesia'
      if country_name =~ /Micronesia, Fed\. Sts\./ || country_name =~ /Micronesia, Fed\.States of/
        @country_name = "Micronesia (Federated States of)"
      end
    elsif country_name.include? 'Kitts'
      @country_name = "Saint Kitts and Nevis"
    elsif country_name.include? 'Hong Kong SAR'
      @country_name = "Hong Kong SAR, China"
    elsif country_name.include? 'Macau (SAR)'
      @country_name = "Macao SAR, China"
    elsif country_name.include? 'Switzrld,Liechtenstein'
      @country_name = "Switzerland and Liechtenstein"
    elsif country_name.include? 'Christmas Is.(Aust)'
      @country_name = "Christmas Island"
    elsif country_name.include? 'Falkland Is. (Malvinas)'
      @country_name = "Falkland Islands"
    elsif country_name.include? 'St. Helena and Depend.'
      @country_name = "Saint Helena and Dependencies"
    elsif country_name.include? 'St. Pierre-Miquelon'
      @country_name = "Saint Pierre and Miquelon"
    elsif country_name.include? 'Wallis & Futuna Isl'
      @country_name = "Wallis and Futuna Island"
    elsif country_name.include? 'East Timor'
      @country_name = "Timor-Leste"
    elsif country_name.include? 'Moldova'
      @country_name = "Republic of Moldova"
    elsif country_name.include? 'St. Lucia'
      @country_name = "Saint Lucia"
    elsif country_name.include? 'Tanzania'
      @country_name = "United Republic of Tanzania"
    end
    set_country
  end
end