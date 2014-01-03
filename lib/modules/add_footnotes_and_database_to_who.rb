class AddFootnotesandDatabasetoWho
  require "rexml/document"
  include REXML

  def gender?(doc)
    doc.root.elements['data'].elements['record'].elements.each do |field|
      if field.attributes['name'] == "GENDER"
        return true
        break
      end
    end
    false
  end

  def xml_parser(file, organization_name, dataset_name, measurement)
    @organization = Organization.find_by_name(organization_name)
    @dataset = Dataset.find_by_name(dataset_name)
    @dataset_id = @dataset.id
    @database = Database.find_or_create_by_name_and_organization_id("WHO Data", @organization.id)
    @organization.databases << @database
    @organization.save
    @dataset.push(topics: "Health")
    @dataset.set(database_id: @database.id)
    @dataset.save

    doc = Document.new File.new(file)
    doc.elements.each("ROOT/footnotes/footnote") do |footnote|
      number = footnote.attributes["footnoteSeqID"]
      text = footnote.text
      footnote = Footnote.create(number: number.to_i, dataset_id: @dataset.id, text: text)
    end

    if gender?(doc)
      doc.elements.each("ROOT/data/record/field") do |element|
        if element.attributes["name"] == "Country or Area"
          @country_name = element.text.strip
          @country = Country.find_by_name(@country_name)
        elsif element.attributes["name"] == "Year(s)"
          @year = element.text.to_i
        elsif element.attributes["name"] == "Value"
          @value = element.text.to_f
        elsif element.attributes["name"] == "GENDER"
          @gender = element.text
        elsif element.attributes["name"] == "Value Footnotes"
          record = Record.find_by_country_id_and_dataset_id_and_year_and_value_and_gender(@country.id, @dataset_id, @year, @value, @gender) 
          record[:area_name] = @country_name
          if element.text != nil && !element.text.include?(",")
            footnote_number = element.text
            footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first 
            record.footnotes << footnote
            record.save
          elsif element.text != nil && element.text.include?(",")
            footnote_numbers = element.text.split(",")
            footnote_numbers.each do |footnote_number|
              footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first
              record.footnotes << footnote
              record.save
            end
          end
          record.save 
        end
      end
    else
      doc.elements.each("ROOT/data/record/field") do |element|
        if element.attributes["name"] == "Country or Area"
          @country_name = element.text.strip
          @country = Country.find_by_name(@country_name)
        elsif element.attributes["name"] == "Year(s)"
          @year = element.text.to_i
        elsif element.attributes["name"] == "Value"
          @value = element.text.to_f
        elsif element.attributes["name"] == "Value Footnotes"
          record = Record.find_by_country_id_and_dataset_id_and_year_and_value(@country.id, @dataset_id, @year, @value)
          record[:area_name] = @country_name
          if element.text != nil && !element.text.include?(",")
            footnote_number = element.text
            footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first
            record.footnotes << footnote
            record.save
          elsif element.text != nil && element.text.include?(",")
            footnote_numbers = element.text.split(",")
            footnote_numbers.each do |footnote_number|
              footnote = Footnote.where(number: footnote_number.to_i, dataset_id: @dataset.id).first
              record.footnote << footnote
              record.save
            end
          end
          record.save
        end
      end 
    end
  end
end
