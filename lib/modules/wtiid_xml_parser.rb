require "#{Rails.root}/lib/modules/xml_parser.rb"

class WtiidXmlParser < XmlParser

  # def xml_parser(directory_name, filename)
  #   @doc = Document.new File.new(directory_name + filename)
  #   get_dataset_name(filename)
  #   set_topics
  #   set_dataset_rel_and_attr
  #   get_footnotes
  #   record_attributes
  # end

  def un_abrev_country_name(country_name)
    case country_name
    when /Rep\./
      country_name.gsub!(/(Rep\.)/, "Republic")
    when /Dem\./
      country_name.gsub!(/(Dem\.)/, "Democratic")
    end
    normalize_country_name(country_name)
  end

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
      new_record.save
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

    case country_name
    when /Bolivia/
      @country_name = "Bolivia (Plurinational State of)"
    when /United States/
      @country_name = "United States of America"
    when /Congo \(Democratic Republic of the\)$/
      @country_name = "Democratic Republic of the Congo"
    when /d'Ivoire/
      @country_name = "Côte d'Ivoire"
    when /Hong Kong/
      @country_name = "Hong Kong SAR, China"
    when /Korea \(Republic of\)$/
      @country_name = "Republic of Korea"
    when /Lao/
      @country_name =  "Lao People's Democratic Republic"
    when /Libya/
      @country_name = "Libya Republic of Jamahiriya"
    when /Macao, China/
      @country_name = "Macao SAR, China"
    when /Micronesia \(Fed\. States of\)/
      @country_name = "Micronesia (Federated States of)"
    when /Moldova/
      @country_name = "Republic of Moldova"
    when /Russia/
      @country_name = "Russian Federation"
    when /Grenadines/
      @country_name = "Saint Vincent and the Grenadines"
    when /Syria$/
      @country_name = "Syrian Arab Republic"
    when /Macedonia/
      @country_name = "The former Yugoslav Republic of Macedonia"
    when /Venezuela/
      @country_name = "Venezuela (Bolivarian Republic of)"
    end

    set_country
  end


end