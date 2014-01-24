require "#{Rails.root}/lib/modules/xml_parser.rb"

class GgidXmlParser < XmlParser

  def xml_parser(directory_name, filename)
    @doc = Document.new File.new(directory_name + filename)
    set_dataset_rel_and_attr(filename)
    record_attributes
  end
  
end