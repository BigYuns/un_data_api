require "#{Rails.root}/lib/modules/xml_parser.rb"
require "#{Rails.root}/lib/modules/wb_xml_parser.rb"
require "#{Rails.root}/lib/modules/test_parser.rb"

namespace :xml_parser do
  desc "get WHO countries" 
  task who_countries: :environment do
    parser = TestCountryNamesParser.new("WHO", "WHO Data", "footnoteSeqID")
  end

  desc "parse WHO"
  task who: :environment do
    parser = WhoXmlParser.new("WHO", "WHO Data", "footnoteSeqID")
  end

  namespace :unsd do
    desc "parse Environment Statistics Database"
    task esd: :environment do
      parser = XmlParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    end

    desc "tests the country names for esd"
    task esd_countries: :environment do
      parser = TestCountryNamesParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    end
    
    desc "parse Industrial Commodity Statistics Database"
    task icsd: :environment do 
      parser = XmlParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end

    desc "tests the country names for icsd"
    task icsd_countries: :environment do
      parser = TestCountryNamesParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end
  end

  namespace :wb do
    desc "parse World Developer Indicators"
    task wdi: :environment do
      parser = WdiXmlParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end

    desc "tests the country names for wdi"
    task wdi_countries: :environment do
      parser = TestCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end
  end
end
