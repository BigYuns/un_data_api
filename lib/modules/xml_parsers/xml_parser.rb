require "find"

class XmlParser
  require "rexml/document"
  include REXML
#  Initialize the parser with the organization name database name, and the name of the footnote sequence id.
#   1. The organization name needs to match up EXACTLY with the name used in the directory.
#   2. The database name needs to match up EXACTLY with the name used in the directory.
#   3. The name of the footnote sequence id will found at the bottom of the xml file under the <footnote> tag.
#     Example: <footnote fnSeqID="1">Footnote Text</footnote>
#              footnote_id_name = "fnSeqID"

  def initialize(organization_name, organization_full_name, database_name, footnote_id_name)
    @organization_name = organization_name
    @database_name = database_name
    organization = Organization.find_or_create_by_name_and_full_name(@organization_name, organization_full_name)
    @organization_id = organization.id
    @database = Database.find_or_create_by_name(@database_name)
    @database.organization = organization
    organization.save
    organization = nil
    @footnote_id_name = footnote_id_name
    directory_name = "lib/un_data_xml_files/#{@organization_name}/#{@database_name}/"
    get_file_names(directory_name)
  end

  def get_file_names(directory_name)
    @topics = []

#   Finds all the paths that are under the database's directory
    full_directory_array = Find.find(directory_name).to_a
    full_directory_array.delete_if {|path| path =~ /.DS_Store/}

#   Iterates over the array of the paths under the directory
    full_directory_array.each_with_index do |path, i|

#   If the next path ends with a file(.xml) then it finds the previous element which is the directory
#   used to get all the filenames in that directory.
#   The directory name is used as a topic on the dataset name.
      if path =~ /\.xml/
        unless full_directory_array[i-1] =~ /\.xml/
          file_dir = full_directory_array[i-1]
          file_dir += '/'
          file_name_array(file_dir)
          @topics = []
        end
      end
      unless path == directory_name || path =~ /\.xml/
        get_topic(path, directory_name)
      end
    end
  end

# Collects the topic names from the directory names.
  def get_topic(path, directory_name)
    topic_path = path.gsub(/#{directory_name}/, "")
    path_array = topic_path.split("/")
    path_array.each do |topic|
      @topics.push(topic)
    end
  end

# Iterates over the files in the directory and pushes them into the xml_parser
  def file_name_array(directory_name)
    filenames_array = []
    Dir.foreach(directory_name) do |filename|
      unless filename == "." || filename == ".." || filename == ".DS_Store"
        filenames_array << filename
      end
    end
    parse_filenames(directory_name, filenames_array)
  end

  def parse_filenames(directory_name, filenames_array)
    filenames_array.each do |filename|
      xml_parser(directory_name, filename)
    end
  end

# Creates a doc from the xml file so the parser can traverse through the elements.
# This function triggers the rest of the parser.
  def xml_parser(directory_name, filename)
    @doc = Document.new File.new(directory_name + filename)
    get_dataset_name(filename)
    set_topics
    set_dataset_rel_and_attr
    get_footnotes
    record_attributes
    @dataset.save
  end

# Gets the dataset name from the xml filename
  def get_dataset_name(filename)
    @dataset_name = filename.chomp(".xml")
    @dataset_name.gsub!(/\%/, "percent")
    @dataset = Dataset.find_or_create_by_name(@dataset_name)
  end

# Sets relationships to do with datasets
  def set_dataset_rel_and_attr
    @dataset.database = @database
    @dataset_id = @dataset.id
    organization = Organization.find_by_id(@organization_id)
    organization.datasets << @dataset
    @dataset.organization = organization
  end

# Sets the topics for the dataset.  If the dataset has no topics specified it defaults to the database name.
  def set_topics
    if @topics == [] || @topics == nil
      @topics = []
      @topics.push(@database_name)
    end
    @topics.uniq!
    @topics.each {|topic| @dataset.topics << topic}
  end

# Makes footnote objects out of the footnotes for the dataset. 
  def get_footnotes
    @doc.elements.each("ROOT/footnotes/footnote") do |footnote|
      number = footnote.attributes[@footnote_id_name]
      text = footnote.text
      footnote = Footnote.create(number: number, dataset_id: @dataset_id, text: text)
    end
  end

# Grabs the attributes from each record and triggers the corresponding methods to set the attributes.
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
        when "Year(s)"
          year = element.text.to_i
          set_year(year)
        when "Unit"
          measurement = element.text
          if measurement == "%"
            measurement = "percent"
          end
          set_record("measurement", measurement)
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
      new_record = Record.new(@record)
      @country.records << new_record
    end
  end

  def un_abrev_country_name(country_name)
    if country_name.include? 'Rep.'
      country_name.gsub!(/(Rep\.)/, "Republic")
    elsif country_name.include? 'Dem.'
      country_name.gsub!(/(Dem\.)/, "Democratic")
    end
    normalize_country_name(country_name)
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
      if @country_name.include? 'Democratic'
        @country_name = "Democratic People's Republic of Korea"
      else
        @country_name = "Republic of Korea"
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
    elsif country_name.include? 'Kitts'
      @country_name = "Saint Kitts and Nevis"
    elsif country_name.include? 'Hong Kong SAR'
      @country_name = "Hong Kong SAR, China"
    elsif country_name.include? 'Hong Kong,'
      @country_name = "Hong Kong SAR, China"
    elsif country_name.include? 'Macau (SAR)'
      @country_name = "Macao SAR, China"
    elsif country_name.include? 'Macao SAR'
      @country_name = "Macao SAR, China"
    elsif country_name.include? 'Yemen, Rep.'
      @country_name = "Yemen"
    elsif country_name.include? 'Switzrld,Liechtenstein'
      @country_name = "Switzerland and Liechtenstein"
    elsif country_name.include? 'Christmas Is.(Aust)'
      @country_name = "Christmas Island"
    elsif country_name.include? 'Falkland Is. (Malvinas)'
      @country_name = "Falkland Islands"
    elsif country_name.include? 'St. Helena and Depend.'
      @country_name = "Saint Helena and Dependencies"
    elsif country_name.include? 'St. Pierre-Miquelon'
      @country_name = "Saint Pierre and Miquelon"
    elsif country_name.include? 'Wallis & Futuna Isl'
      @country_name = "Wallis and Futuna Island"
    elsif country_name.include? 'Vietnam'
      @country_name = "Viet Nam"
    elsif country_name.include? 'East Timor'
      @country_name = "Timor-Leste"
    elsif country_name.include? 'Moldova'
      @country_name = "Republic of Moldova"
    elsif country_name.include? 'St. Lucia'
      @country_name = "Saint Lucia"
    elsif country_name.include? 'China, People\'s Republic of'
      @country_name = "China"
    elsif country_name.include? 'Macao, China'
      @country_name = "Macao SAR, China"
    elsif country_name.include? 'Russia'
      @country_name = "Russian Federation"
    elsif country_name =~ /Syria$/
      @country_name = "Syrian Arab Republic"
    elsif country_name.include? 'Former Democratic Yemen'
      @country_name = "Former Democratic Yemen"
    elsif country_name.include? 'Former Yemen Arab Republic'
      @country_name = "Former Yemen Arab Republic"
    elsif country_name.include? 'Yemen, Republic'
      @country_name = "Yemen"
    elsif country_name.include? 'United Kingdom'
      @country_name = "United Kingdom"
    elsif country_name.include? 'Tanzania'
      @country_name = "United Republic of Tanzania"
    elsif country_name.include? 'Gambia, The'
      @country_name = "Gambia"
    elsif country_name.include? 'Micronesia'
      if country_name =~ /Micronesia, Fed\. Sts\./ || country_name =~ /Micronesia, Fed\.States of/
        @country_name = "Micronesia (Federated States of)"
      elsif country_name =~ /Micronesia \(Fed\. States of\)/
        @country_name = "Micronesia (Federated States of)"
      end
    end
    set_country
  end

  def set_country
    if Country.find_by_name(@country_name) == nil
      puts @country_name
    end
    @country = Country.find_or_create_by_name(@country_name)
    organization = Organization.find_by_id(@organization_id)
    @country.organizations << organization
    organization.countries << @country
    @country.datasets << @dataset
    @dataset.countries << @country
    @country.save
    organization.save
  end

  def set_year(year)
    @record = { year: year, 
                dataset_id: @dataset_id, 
                country_id: @country.id,
                area_name: @original_country_name,
              }
  end

  def clean_footnotes(element_text)
    if element_text.include?(",")
      footnote_numbers = element_text.split(",")
      footnote_numbers.each do |footnote_number|
        set_record_footnote(footnote_number)
      end
    else
      set_record_footnote(element_text)
    end
  end

  def set_record_footnote(footnote_number)
    footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset_id).first
    if @record[:footnote_ids]    
      @record[:footnote_ids] << footnote.id
    else
      @record[:footnote_ids] = [footnote.id]
    end
  end

  def set_record(attribute_name, attribute)
    @record[attribute_name.to_sym] = attribute
  end

end
