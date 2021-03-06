require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"

# National Accounts Estimates of Main Aggregates
class NaemaXmlParser < XmlParser

  def xml_parser(directory_name, filename)
    file = File.new(directory_name + filename)
    @doc = Document.new file
    get_dataset_name(filename)
    set_topics
    set_dataset_rel_and_attr
    record_attributes
    @dataset.save
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

    if country_name.include? 'United States'
      @country_name = "United States of America"
    elsif country_name.include? 'Bolivia'
      @country_name = "Bolivia (Plurinational State of)"
    elsif country_name.include? 'Libya'
      @country_name = "Libya"
    elsif country_name.include? 'Venezuela'
      @country_name = "Venezuela (Bolivarian Republic of)"
    elsif country_name.include? 'Iran'
      @country_name = "Iran (Islamic Republic of)"
    elsif country_name.include? 'Hong Kong SAR'
      @country_name = "Hong Kong SAR, China"
    elsif country_name.include? 'Macao SAR'
      @country_name = "Macao SAR, China"
    elsif country_name.include? 'China, People\'s Republic of'
      @country_name = "China"
    elsif country_name.include? 'United Kingdom'
      @country_name = "United Kingdom"
    elsif country_name.include? 'Former Democratic Yemen'
      @country_name = "Former Democratic Yemen"
    elsif country_name.include? 'Former Yemen Arab Republic'
      @country_name = "Former Yemen Arab Republic"
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
      @country.records << new_record
    end
  end

  def get_dataset_name(filename)
    super
    puts @dataset.name
    @measurement = /-\s+(.*)/.match(@dataset_name, 1).captures[0]
  end

end