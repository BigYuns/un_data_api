require "#{Rails.root}/lib/modules/xml_parser.rb"

class EsdParser < XmlParser

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
    when /d'Ivoire/
      @country_name = "Côte d'Ivoire"
    when /Hong Kong SAR/
      @country_name = "Hong Kong SAR, China"
    when /Macao SAR/
      @country_name = "Macao SAR, China"
    end
    set_country
  end

end