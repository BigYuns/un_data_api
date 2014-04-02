require "#{Rails.root}/lib/modules/xml_parser.rb"
require "#{Rails.root}/lib/modules/wdi_xml_parser.rb"
require "#{Rails.root}/lib/modules/test_country_names_parser.rb"
require "#{Rails.root}/lib/modules/seed_country_names_parser.rb"
require "#{Rails.root}/lib/modules/ggid_xml_parser.rb"
require "#{Rails.root}/lib/modules/esd_xml_parser.rb"
require "#{Rails.root}/lib/modules/xml_parser.rb"
require "#{Rails.root}/lib/modules/icsd_xml_parser.rb"
require "#{Rails.root}/lib/modules/naema_xml_parser.rb"

namespace :xml_parser do
  namespace :all_countries do
    desc "populate all the country names in the database"
    task names: :environment do
      SeedCountryNamesParser.new("WHO", "WHO Data", "footnoteSeqID")
      SeedCountryNamesParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
      SeedCountryNamesParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
      SeedCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
      # SeedCountryNamesParser.new("UNFCCC", "Greenhouse Gas Inventory Data", "none")
      # SeedCountryNamesParser.new("UNSD", "National Accounts Estimates of Main Aggregates", "none")
      # SeedCountryNamesParser.new("ITU", "World Telecommunication and ICT Indicators Database", "footnoteSeqID")
      # SeedCountryNamesParser.new("UNSD", "Global Indicators Database", "")

    end
  end

  desc "get WHO countries" 
  task who_countries: :environment do
    TestCountryNamesParser.new("WHO", "WHO Data", "footnoteSeqID")
  end

  desc "parse WHO"
  task who: :environment do
    WhoXmlParser.new("WHO", "WHO Data", "footnoteSeqID")
  end

  namespace :unsd do
    desc "parse Environment Statistics Database"
    task esd: :environment do
      EsdXmlParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    end

    desc "tests the country names for Environment Statistics Database"
    task esd_countries: :environment do
      TestCountryNamesParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    end
    
    desc "parse Industrial Commodity Statistics Database"
    task icsd: :environment do 
      IcsdXmlParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end

    desc "tests the country names for Industrial Commodity Statistics Database"
    task icsd_countries: :environment do
      TestCountryNamesParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end

    desc "parse National Accounts Estimates of Main Aggregates"
    task naema: :environment do 
      NaemaXmlParser.new("UNSD", "National Accounts Estimates of Main Aggregates", "none")
    end

    desc "tests the country names of National Accounts Estimates of Main Aggregates"
    task naema_countries: :environment do
      TestCountryNamesParser.new("UNSD", "National Accounts Estimates of Main Aggregates", "none")
    end

    desc "parse Global Indicator Database"
    task gid: :environment do 
      GidXmlParser.new("UNSD", "Global Indicators Database", "")
    end

    desc "tests the country names of Global Indicator Database"
    task gid_countries: :environment do
      TestCountryNamesParser.new("UNSD", "Global Indicators Database", "")
    end
  end

  namespace :wb do
    desc "parse World Development Indicators"
    task wdi: :environment do
      WdiXmlParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end

    desc "tests the country names for wdi"
    task wdi_countries: :environment do
      TestCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end
  end

  namespace :itu do
    desc "parse World Telecommunitcation and ICT Indicators Database"
    task wtiid: :environment do
      WtiidXmlParser.new("ITU", "World Telecommunication and ICT Indicators Database", "footnoteSeqID")
    end

    desc "tests the country names for wtiid"
    task wtiid_countries: :environment do
      TestCountryNamesParser.new("ITU", "World Telecommunication and ICT Indicators Database", "footnoteSeqID")
    end
  end

  namespace :unfccc do
    desc "parse Greenhouse Gas Inventory Data"
    task ggid: :environment do
      GgidXmlParser.new("UNFCCC", "Greenhouse Gas Inventory Data", "none")
    end

    desc "tests the country names for Greenhouse Gas Inventory Data"
    task ggid_countries: :environment do
      TestCountryNamesParser.new("UNFCCC", "Greenhouse Gas Inventory Data", "none")
    end
  end
end
