require "#{Rails.root}/lib/modules/xml_parser.rb"

class TestCountryNamesParser < XmlParser

  def set_country
    if Country.find_by_name(@country_name) == nil
      puts @country_name
      @country = Country.find_or_create_by_name(@country_name)
    end
  end

  def xml_parser(directory_name, filename)
    @doc = Document.new File.new(directory_name + filename)
    record_attributes
  end

  def record_attributes
    @doc.elements.each("ROOT/data/record") do |record|
      record.elements.each do |element|
        element_name = element.attributes["name"]
        if element_name == "Country or Area"
          @original_country_name = element.text.strip
          @country_name = @original_country_name
          un_abrev_country_name(@country_name)
        end
      end
    end
  end
end