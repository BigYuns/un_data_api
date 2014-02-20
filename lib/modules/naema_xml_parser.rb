require "#{Rails.root}/lib/modules/xml_parser.rb"

class NaemaXmlParser < XmlParser

  def xml_parser(directory_name, filename)
    @doc = Document.new File.new(directory_name + filename)
    get_dataset_name(filename)
    set_topics
    set_dataset_rel_and_attr
    record_attributes
  end

  def get_file_names(directory_name)
    @topics = []
    full_directory_array = Find.find(directory_name).to_a
    full_directory_array.delete_if {|path| path =~ /.DS_Store/}
    full_directory_array.each_with_index do |path, i|
      if path =~ /\.xml/
        unless full_directory_array[i-1] =~ /\.xml/
          file_dir = full_directory_array[i-1]
          # file_dir += "/"
          file_name_array(file_dir)
          @topics = []
        end
      end
      unless path == directory_name || path =~ /\.xml/
        get_topic(path, directory_name)
      end
    end
  end

  def un_abrev_country_name(country_name)
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
    when /Venezuela/
      @country_name = "Venezuela (Bolivarian Republic of)"
    when /Iran/
      @country_name = "Iran (Islamic Republic of)"
    when /Hong Kong SAR/
      @country_name = "Hong Kong SAR, China"
    when /Macao SAR/
      @country_name = "Macao SAR, China"
    when /China, People's Republic of/
      @country_name = "China"
    when /United Kingdom/
      @country_name = "United Kingdom"
    end
    set_country
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
      new_record.save
    end
  end

  def get_dataset_name(filename)
    super
    puts @dataset.name
    @measurement = /-\s+(.*)/.match(@dataset_name, 1).captures[0]
  end

end