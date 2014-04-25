require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"

# WHO Data
class WdXmlParser < XmlParser

  def record_attributes
    @doc.elements.each("ROOT/data/record") do |record|
      record.elements.each do |element|
        element_name = element.attributes["name"]

        case element_name
        when "Country or Area"
          @original_country_name = element.text.strip
          @country_name = @original_country_name
          un_abrev_country_name(@country_name)
        when "Year(s)"
          year = element.text.to_i
          set_year(year)
        when "Value"
          value = element.text.to_f
          set_record("value", value)
        when "GENDER"
          gender = element.text
          set_record("gender", gender)
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

  def get_file_names(directory_name)
    file_name_array(directory_name)
  end

  def un_abrev_country_name(country_name)
    normalize_country_name(country_name)
  end

  def normalize_country_name(country_name)
    if country_name.include? 'Libya'
      @country_name = "Libya"
    end
    set_country
  end

  def get_dataset_name(filename)
    super
    if @dataset_name == "distributions_of_causes_of_death_among_children_aged_<5_years_HIV-AIDS_percent"
      @dataset_name = "Distribution of causes of death among children aged <5 years - HIV-AIDS (percent)"
    elsif @dataset_name == "deaths_due_to_HIV-AIDS_per_100_000"
      @dataset_name = "Deaths due to HIV-AIDS (per 100,000)"
    end 
    @measurement = @dataset_name[/\(([^)]+)\)/]
    @dataset_name.gsub!(/\(([^)]+)\)/, "")
    @dataset_name.rstrip!
    @measurement.gsub!(/\%/, "percent")
    @measurement.delete!("(")
    @measurement.delete!(")")
    p @dataset_name
  end
end

