require "#{Rails.root}/lib/modules/xml_parser.rb"


class WbXmlParser < XmlParser

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

  def get_dataset_name(filename)
    super
    @measurement = @dataset_name[/\(([^)]+)\)/]
    @measurement.gsub!(/\%/, "percent")
    @measurement.delete!("(")
    @measurement.delete!(")")
  end

end
