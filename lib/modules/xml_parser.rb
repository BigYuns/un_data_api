require "find"

class XmlParser
  require "rexml/document"
  include REXML

  def initialize(organization_name, database_name, footnote_id_name)
    @organization_name = organization_name
    @database_name = database_name
    @organization = Organization.find_or_create_by_name(@organization_name)
    @database = Database.find_or_create_by_name(@database_name)
    @database.organization = @organization
    @footnote_id_name = footnote_id_name
    directory_name = "lib/un_data_xml_files/#{@organization_name}/#{@database_name}/"
    get_file_names(directory_name)
  end

  def get_file_names(directory_name)
    @topics = []
    full_directory_array = Find.find(directory_name).to_a

    full_directory_array.delete_if {|path| path =~ /.DS_Store/}

    full_directory_array.each_with_index do |path, i|
      if path =~ /\.xml/
        unless full_directory_array[i-1] =~ /\.xml/
          file_dir = full_directory_array[i-1]
          file_dir += "/"
          file_name_array(file_dir)
          @topics = []
        end
      end
      unless path == directory_name || path =~ /\.xml/
        get_topic(path)
      end
    end
  end

  def get_topic(path)
    topic = path[/[^\/]*$/]
    @topics.push(topic)
  end

  def file_name_array(directory_name)
    Dir.foreach(directory_name) do |files|
      filenames_array = []
      unless files == "." || files == ".." || files == ".DS_Store"
        filenames_array << files
      end
      parse_filenames(directory_name, filenames_array)
    end
  end   

  def parse_filenames(directory_name, filenames_array)
    filenames_array.each do |filename|
      xml_parser(directory_name, filename)
    end
  end

  def parse_filenames_wb(directory_name, filenames_array)
    filename = filenames_array.pop    
    xml_parser(directory_name, filename)
  end

  def xml_parser(directory_name, filename)
    @doc = Document.new File.new(directory_name + filename)
    set_dataset_rel_and_attr(filename)
    get_footnotes
    record_attributes
  end

  def get_footnotes
    @doc.elements.each("ROOT/footnotes/footnote") do |footnote|
      number = footnote.attributes[@footnote_id_name]
      text = footnote.text
      footnote = Footnote.create(number: number, dataset_id: @dataset_id, text: text)
    end
  end

  def set_dataset_rel_and_attr(filename)
    get_dataset_name(filename)
    if @topics == []
      @topics.push(@database_name)
    end
    @topics.each {|topic| @dataset.topics << topic}
    p @dataset.topics
    @dataset.database = @database
    @dataset_id = @dataset.id
    @organization.datasets << @dataset
    @dataset.organization = @organization
    @dataset.save
  end

  def get_dataset_name(filename)
    @dataset_name = filename.chomp(".xml")
    @dataset_name.gsub!(/\%/, "percent")
    puts @dataset_name
    @dataset = Dataset.find_or_create_by_name(@dataset_name)
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
        when "Year" || "Year(s)"
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
      new_record.save
    end
  end

  def un_abrev_country_name(country_name)
    case country_name
    when /Rep\./
      country_name.gsub!(/(Rep\.)/, "Republic")
    when /Dem\./
      country_name.gsub!(/(Dem\.)/, "Democratic")
    end
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
    when /Macedonia/
      @country_name = "The former Yugoslav Republic of Macedonia"
    when /Korea/
      if country_name.include?("Democratic")
        @country_name = "Democratic People's Republic of Korea"
        set_country
      else
        @country_name = "Republic of Korea"
        set_country
      end
    when /Congo/
      if country_name.include?("Rep") && !country_name.include?("Dem")
        @country_name = "Congo"
      elsif country_name.include?("Dem")
        @country_name = "Democratic Republic of the Congo"
      end
    when /Grenadines/
      @country_name = "Saint Vincent and the Grenadines"
    when /d'Ivoire/
      @country_name = "Côte d'Ivoire"
    when /Venezuela/
      @country_name = "Venezuela (Bolivarian Republic of)"
    when /Bahamas/
      @country_name = "Bahamas"
    when /Egypt/
      @country_name = "Egypt"
    when /Iran/
      @country_name = "Iran (Islamic Republic of)"
    when /Kyrgyz Republic/
      @country_name = "Kyrgyzstan"
    when /Lao/
      @country_name =  "Lao People's Democratic Republic"
    when /Micronesia/
      if country_name =~ /Micronesia, Fed\. Sts\./ || country_name =~ /Micronesia, Fed\.States of/
        @country_name = "Micronesia (Federated States of)"
      end
    when /Kitts/
      @country_name = "Saint Kitts and Nevis"
    when /Hong Kong SAR/
      @country_name = "Hong Kong SAR, China"
    when /Macau \(SAR\)/
      @country_name = "Macao SAR, China"
    when /Macao SAR/
      @country_name = "Macao SAR, China"
    when /Tanzania/
      @country_name = "United Republic of Tanzania"
    when /Yemen/
      @country_name = "Yemen"
    when /Switzrld,Liechtenstein/
      @country_name = "Switzerland and Liechtenstein"
    when /Christmas Is\.\(Aust\)/
      @country_name = "Christmas Island"
    when /Falkland Is\. \(Malvinas\)/
      @country_name = "Falkland Islands"
    when /St\. Helena and Depend\./
      @country_name = "Saint Helena and Dependencies"
    when /St\. Pierre-Miquelon/
      @country_name = "Saint Pierre and Miquelon"
    when /Wallis \& Futuna Isl/
      @country_name = "Wallis and Futuna Island"
    when /Vietnam/
      @country_name = "Viet Nam"
    when /East Timor/
      @country_name = "Timor-Leste"
    when /Moldova/
      @country_name = "Republic of Moldova"
    when /St. Lucia/
      @country_name = "Saint Lucia"
    end
    set_country
  end

  def set_country
    if Country.find_by_name(@country_name) != nil
      @country = Country.find_or_create_by_name(@country_name)
    else
      p @country_name
      @country = Country.find_or_create_by_name(@country_name)
    end

    @country.organizations << @organization
    @organization.countries << @country
    @organization.save

    @country.datasets << @dataset
    @country.save

    @dataset.countries << @country
    @dataset.save
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
