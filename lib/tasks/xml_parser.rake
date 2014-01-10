require "#{Rails.root}/lib/modules/xml_parser.rb"
require "#{Rails.root}/lib/modules/wb_xml_parser.rb"

namespace :xml_parser do
  desc "parse WHO"
  task who: :environment do
    parser = WhoXmlParser.new("WHO", "WHO Data", "footnoteSeqID")
    # parser.get_file_names("WHO", "WHO Data", "footnoteSeqID")
  end

  namespace :unsd do
    desc "parse Environment Statistics Database"
    task esd: :environment do
      parser = XmlParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
      # parser.get_file_names_mult_dir("UNSD", "Environment Statistics Database", "fnSeqID")
    end
    
    desc "parse Industrial Commodity Statistics Database"
    task icsd: :environment do 
      parser = XmlParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end
  end

  namespace :wb do
    desc "parse World Developer Indicators"
    task wdi: :environment do
      parser = WbXmlParser.new("WB", "World Development Indicators", "footnoteSeqID")
      # parser.get_file_names("WB", "World Development Indicators", "footnoteSeqID")
    end
  end
end
