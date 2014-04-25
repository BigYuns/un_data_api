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
      @country.records << new_record
    end
  end

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
    elsif country_name.include? 'd\'Ivoire'
      @country_name = "Côte d'Ivoire"
    elsif country_name.include? 'Venezuela'
      @country_name = "Venezuela (Bolivarian Republic of)"
    elsif country_name.include? 'Bahamas'
      @country_name = "Bahamas"
    elsif country_name.include? 'Egypt'
      @country_name = "Egypt"
    elsif country_name.include? 'Iran'
      @country_name = "Iran (Islamic Republic of)"
    elsif country_name.include? 'Kyrgyz Republic'
      @country_name = "Kyrgyzstan"
    elsif country_name.include? 'Lao'
      @country_name =  "Lao People's Democratic Republic"
    elsif country_name.include? 'Micronesia'
      if country_name =~ /Micronesia, Fed\. Sts\./ || country_name =~ /Micronesia, Fed\.States of/
        @country_name = "Micronesia (Federated States of)"
      end
    elsif country_name.include? 'Kitts'
      @country_name = "Saint Kitts and Nevis"
    elsif country_name.include? 'Yemen, Rep\.'
      @country_name = "Yemen"
    elsif country_name.include? 'Vietnam'
      @country_name = "Viet Nam"
    elsif country_name.include? 'East Timor'
      @country_name = "Timor-Leste"
    elsif country_name.include? 'Moldova'
      @country_name = "Republic of Moldova"
    elsif country_name.include? 'St. Lucia'
      @country_name = "Saint Lucia"
    elsif country_name.include? 'Tanzania'
      @country_name = "United Republic of Tanzania"
    elsif country_name.include? 'Gambia, The'
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
