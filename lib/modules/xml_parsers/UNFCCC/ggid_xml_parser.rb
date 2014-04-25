require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"

# Greenhouse Gas Inventory Data
class GgidXmlParser < XmlParser

  def xml_parser(directory_name, filename)
    @doc = Document.new File.new(directory_name + filename)
    get_dataset_name(filename)
    set_topics
    set_dataset_rel_and_attr
    record_attributes
    @dataset.save
  end

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
    end
    set_country
  end

  def get_dataset_name(filename)
    @dataset_name = filename.chomp(".xml")
    @dataset_name.gsub!(/\%/, "percent")
    puts @dataset_name
    if @dataset_name == "Carbon dioxide (CO2) Emissions without Land Use, Land-Use Change and Forestry (LULUCF), in Gigagrams (Gg)"
      @measurement = "in Gigagrams (Gg)"
    else
      @measurement = "in Gigagrams (Gg) CO2 equivalent"
    end
    @dataset = Dataset.find_or_create_by_name(@dataset_name)
  end

end