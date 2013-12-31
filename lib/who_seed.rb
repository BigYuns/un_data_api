class WhoParser
  require "rexml/document"
  include REXML

  def xml_parser(file, organization_name, dataset_name, measurement)

    @organization = Organization.find_or_create_by_name(organization_name)
    @dataset = Dataset.find_or_create_by_name_and_organization_id(dataset_name, @organization.id)
    @organization.datasets << @dataset

    doc = Document.new File.new(file)
    doc.elements.each("ROOT/data/record/field") do |element|

      if element.attributes["name"] == "Country or Area"
        country_name = element.text.strip
        @country = Country.find_or_create_by_name(country_name)
        @country.organizations << @organization
        @organization.countries << @country
        @organization.save
        if @country.datasets.include?(@dataset)
          @country.save
        else
          @country.datasets << @dataset
          @country.save
        end
        @dataset.countries << @country
        @dataset.save
      elsif element.attributes["name"] == "Year(s)"
        year = element.text.to_i
        Record.create(year: year, dataset_id: @dataset.id, country_id: @country.id, measurement: measurement, value: 0)
      elsif element.attributes["name"] == "Value"
        record = Record.last
        value = element.text.to_f
        record.set(value: value)
        record.reload
        p record.value
      elsif element.attributes["name"] == "GENDER"
        record = Record.last
        gender = element.text
        record.set(gender: gender)
        record.reload
      end 
    end
  end
end