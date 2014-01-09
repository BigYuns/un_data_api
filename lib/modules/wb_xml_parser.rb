require "#{Rails.root}/lib/modules/xml_parser.rb"
require "#{Rails.root}/lib/modules/single_dir_parser.rb"


class WbXmlParser < SingleDirParser

  def initialize(organization_name, database_name, footnote_id_name)
    super
    get_file_names
  end

end