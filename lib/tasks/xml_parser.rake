require "#{Rails.root}/lib/modules/xml_parser.rb"
require "#{Rails.root}/lib/modules/wb_xml_parser.rb"

namespace :xml_parser do
  desc "TODO"
  task who: :environment do
    parser = XmlParser.new
    parser.get_file_names("WHO", "WHO Data", "footnoteSeqID")
  end

  task unsd: :environment do
    parser = XmlParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    # parser.get_file_names_mult_dir("UNSD", "Environment Statistics Database", "fnSeqID")
  end

  task wb: :environment do
    parser = WbXmlParser.new("WB", "World Development Indicators", "footnoteSeqID")
    # parser.get_file_names("WB", "World Development Indicators", "footnoteSeqID")
  end

end
