require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"

# World Development Indicators
class WdiXmlParser < XmlParser

  def record_attributes
    @doc.elements.each("ROOT/data/record") do |record|
      record.elements.each do |element|
        element_name = element.attributes["name"]

        case element_name
        when "Country or Area"
          @original_country_name = element.text.strip
          @country_name = @original_country_name
          normalize_country_name(@country_name)
        when "Year"
          year = element.text.to_i
          set_year(year)
        when "Value"
          value = element.text.to_f
          set_record("value", value)
        when "Value Footnotes" 
          if element.text != nil 
            clean_footnotes(element.text)
          end
        else
          name = element_name.downcase.gsub("/ /", "_")
          set_record(name, element.text)
        end
      end
      set_record("measurement", @measurement)    
      new_record = Record.new(@record)
      new_record.save
    end
  end

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
      @country_name = "Libya"
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
    when /d'Ivoire/
      @country_name = "Côte d'Ivoire"
    when /Venezuela/
      @country_name = "Venezuela (Bolivarian Republic of)"
    when /Bahamas/
      @country_name = "Bahamas"
    when /Egypt/
      @country_name = "Egypt"
    when /Iran/
      @country_name = "Iran (Islamic Republic of)"
    when /Kyrgyz Republic/
      @country_name = "Kyrgyzstan"
    when /Lao/
      @country_name =  "Lao People's Democratic Republic"
    when /Micronesia/
      if country_name =~ /Micronesia, Fed\. Sts\./ || country_name =~ /Micronesia, Fed\.States of/
        @country_name = "Micronesia (Federated States of)"
      end
    when /Kitts/
      @country_name = "Saint Kitts and Nevis"
    when /Yemen, Republic/
      @country_name = "Yemen"
    when /Vietnam/
      @country_name = "Viet Nam"
    when /East Timor/
      @country_name = "Timor-Leste"
    when /Moldova/
      @country_name = "Republic of Moldova"
    when /St. Lucia/
      @country_name = "Saint Lucia"
    when /Tanzania/
      @country_name = "United Republic of Tanzania"
    when /Gambia, The/
      @country_name = "Gambia"
    end
    set_country
  end

  def get_dataset_name(filename)
    super
    @measurement = @dataset_name[/\(([^)]+)\)/]
    @measurement.gsub!(/\%/, "percent")
    @measurement.delete!("(")
    @measurement.delete!(")")
  end

end
