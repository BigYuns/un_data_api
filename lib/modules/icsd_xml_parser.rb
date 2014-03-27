require "#{Rails.root}/lib/modules/xml_parser.rb"

class IcsdXmlParser < XmlParser

  def un_abrev_country_name(country_name)
    case country_name
    when /Rep\./
      country_name.gsub!(/(Rep\.)/, "Republic")
    when /Dem\./
      country_name.gsub!(/(Dem\.)/, "Democratic")
    end
    normalize_country_name(country_name)
  end

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
    when /Congo/
      if country_name.include?("Rep") && !country_name.include?("Dem")
        @country_name = "Congo"
      elsif country_name.include?("Dem")
        @country_name = "Democratic Republic of the Congo"
      end
    when /Grenadines/
      @country_name = "Saint Vincent and the Grenadines"
    when /Venezuela/
      @country_name = "Venezuela (Bolivarian Republic of)"
    when /Iran/
      @country_name = "Iran (Islamic Republic of)"
    when /Lao/
      @country_name =  "Lao People's Democratic Republic"
    when /Micronesia/
      if country_name =~ /Micronesia, Fed\. Sts\./ || country_name =~ /Micronesia, Fed\.States of/
        @country_name = "Micronesia (Federated States of)"
      end
    when /Kitts/
      @country_name = "Saint Kitts and Nevis"
    when /Hong Kong SAR/
      @country_name = "Hong Kong SAR, China"
    when /Macau \(SAR\)/
      @country_name = "Macao SAR, China"
    when /Switzrld,Liechtenstein/
      @country_name = "Switzerland and Liechtenstein"
    when /Christmas Is\.\(Aust\)/
      @country_name = "Christmas Island"
    when /Falkland Is\. \(Malvinas\)/
      @country_name = "Falkland Islands"
    when /St\. Helena and Depend\./
      @country_name = "Saint Helena and Dependencies"
    when /St\. Pierre-Miquelon/
      @country_name = "Saint Pierre and Miquelon"
    when /Wallis \& Futuna Isl/
      @country_name = "Wallis and Futuna Island"
    when /East Timor/
      @country_name = "Timor-Leste"
    when /Moldova/
      @country_name = "Republic of Moldova"
    when /St. Lucia/
      @country_name = "Saint Lucia"
    when /Tanzania/
      @country_name = "United Republic of Tanzania"
    end
    set_country
  end
end