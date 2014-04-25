require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"

# World Telecommunitcation and ICT Indicators Database
class WtiidXmlParser < XmlParser

  def record_attributes
    @doc.elements.each("ROOT/data/record") do |record|
      record.elements.each do |element|
        element_name = element.attributes["name"]

        case element_name
        when "Country or Area"
          @original_country_name = element.text.strip
          @country_name = @original_country_name
          un_abrev_country_name(@country_name)
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
      p @record    
      new_record = Record.new(@record)
      @country.records << new_record
    end
  end

  def get_dataset_name(filename)
    super
    get_measurement
  end

  def get_measurement
    case @dataset_name
    when "Fixed-telephone subscriptions per 100 inhabitants"
      @measurement = "per 100 inhabitants"
    when "Fixed-telephone subscriptions"
      @measurement = "count"
    when "Mobile-cellular telephone subscriptions per 100 inhabitants"
      @measurement = "per 100 inhabitants"
    when "Mobile-cellular telephone subscriptions"
      @measurement = "count"
    when "Percentage of individuals using the Internet"
      @measurement = "percent"
    end
  end

  def normalize_country_name(country_name)

    if country_name.include? 'Bolivia'
      @country_name = "Bolivia (Plurinational State of)"
    elsif country_name.include? 'United States'
      @country_name = "United States of America"
    elsif country_name.include? 'Congo (Democratic Republic of the)'
      @country_name = "Democratic Republic of the Congo"
    elsif country_name.include? 'd\'Ivoire'
      @country_name = "Côte d'Ivoire"
    elsif country_name.include? 'Hong Kong,'
      @country_name = "Hong Kong SAR, China"
    elsif country_name.include? 'Korea (Republic of)'
      @country_name = "Republic of Korea"
    elsif country_name.include? 'Lao'
      @country_name =  "Lao People's Democratic Republic"
    elsif country_name.include? 'Libya'
      @country_name = "Libya"
    elsif country_name.include? 'Macao, China'
      @country_name = "Macao SAR, China"
    elsif country_name.include? 'Micronesia (Fed. States of)'
      @country_name = "Micronesia (Federated States of)"
    elsif country_name.include? 'Moldova'
      @country_name = "Republic of Moldova"
    elsif country_name.include? 'Russia'
      @country_name = "Russian Federation"
    elsif country_name.include? 'Grenadines'
      @country_name = "Saint Vincent and the Grenadines"
    elsif country_name =~ /Syria$/
      @country_name = "Syrian Arab Republic"
    elsif country_name.include? 'Macedonia'
      @country_name = "The former Yugoslav Republic of Macedonia"
    elsif country_name.include? 'Venezuela'
      @country_name = "Venezuela (Bolivarian Republic of)"
    elsif country_name.include? 'Tanzania'
      @country_name = "United Republic of Tanzania"
    end
    set_country
  end


end