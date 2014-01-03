class XmlParser
  require "rexml/document"
  include REXML

  def get_file_names(organization_name, database_name, footnote_id_name)
    @organization_name = organization_name
    @database_name = database_name
    @organization = Organization.find_or_create_by_name(@organization_name)
    @database = Database.find_or_create_by_name(@database_name)
    @database.organization = @organization
    @footnote_id_name = footnote_id_name

    @directory_name = "un_data_xml_files/#{@organization_name}/#{@database_name}/"

    Dir.foreach(@directory_name) do |dir|
      unless dir == "." || dir == ".." || dir == ".DS_Store"
        @full_directory_name = @directory_name + dir + "/"
        @topic = dir
        Dir.foreach(@full_directory_name) do |files|
          filenames_array = []
          unless files == "." || files == ".." || files == ".DS_Store"
            filenames_array << files
          end
          parse_filenames(filenames_array)
        end
      end
    end
  end   

  def parse_filenames(filenames_array)
    filenames_array.each do |filename|
      xml_parser(filename)
    end
  end

  def xml_parser(filename)
    @doc = Document.new File.new(@full_directory_name + filename)

    @dataset = get_dataset_name(filename)
    @dataset.topics << @topic
    @dataset.database = @database
    @dataset_id = @dataset.id

    @organization.datasets << @dataset
    @dataset.organization = @organization
    @dataset.save

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

  def get_dataset_name(filename)
    dataset_name = filename.chomp(".xml")
    Dataset.find_or_create_by_name(dataset_name)
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
    when /Grenadines/
      @country_name = "Saint Vincent and the Grenadines"
    when /d'Ivoire/
      @country_name = "Côte d'Ivoire"
    when /Venezuela/
      @country_name = "Venezuela (Bolivarian Republic of)"
    end
    set_country
  end

  def set_country
    @country = Country.find_or_create_by_name(@country_name)

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
                area_name: @original_country_name 
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
