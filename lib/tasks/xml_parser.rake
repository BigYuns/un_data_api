require "#{Rails.root}/lib/modules/xml_parsers/xml_parser.rb"


namespace :xml_parser do
  namespace :all_countries do
    desc "populate all the country names in the database"
    task names: :environment do
      SeedCountryNamesParser.new("WHO", "WHO Data", "footnoteSeqID")
      SeedCountryNamesParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
      SeedCountryNamesParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
      SeedCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
      SeedCountryNamesParser.new("UNFCCC", "Greenhouse Gas Inventory Data", "none")
      SeedCountryNamesParser.new("UNSD", "National Accounts Estimates of Main Aggregates", "none")
      SeedCountryNamesParser.new("ITU", "World Telecommunication and ICT Indicators Database", "footnoteSeqID")
    end
  end
  namespace :who do
    desc "test WHO Data countries" 
    task wd_test_countries: :environment do
      TestCountryNamesParser.new("WHO", "WHO Data", "footnoteSeqID")
    end

    desc "seed WHO Data countries" 
    task wd_seed_countries: :environment do
      SeedCountryNamesParser.new("WHO", "WHO Data", "footnoteSeqID")
    end

    desc "parse WHO Data"
    task wd: :environment do
      WdXmlParser.new("WHO", "WHO Data", "footnoteSeqID")
    end
  end 

  namespace :unsd do
    desc "parse Environment Statistics Database"
    task esd: :environment do
      EsdXmlParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    end

    desc "seed the country names for Environment Statistics Database"
    task esd_seed_countries: :environment do
      SeedCountryNamesParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    end

    desc "tests the country names for Environment Statistics Database"
    task esd_test_countries: :environment do
      TestCountryNamesParser.new("UNSD", "Environment Statistics Database", "fnSeqID")
    end
    
    desc "parse Industrial Commodity Statistics Database"
    task icsd: :environment do 
      IcsdXmlParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end

    desc "seed the country names for Industrial Commodity Statistics Database"
    task icsd_seed_countries: :environment do
      SeedCountryNamesParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end

    desc "tests the country names for Industrial Commodity Statistics Database"
    task icsd_test_countries: :environment do
      TestCountryNamesParser.new("UNSD", "Industrial Commodity Statistics Database", "fnSeqID")
    end

    desc "parse National Accounts Estimates of Main Aggregates"
    task naema: :environment do 
      NaemaXmlParser.new("UNSD", "National Accounts Estimates of Main Aggregates", "none")
    end

    desc "tests the country names of National Accounts Estimates of Main Aggregates"
    task naema_test_countries: :environment do
      TestCountryNamesParser.new("UNSD", "National Accounts Estimates of Main Aggregates", "none")
    end

    desc "seeds the country names of National Accounts Estimates of Main Aggregates"
    task naema_seed_countries: :environment do
      SeedCountryNamesParser.new("UNSD", "National Accounts Estimates of Main Aggregates", "none")
    end

    desc "parse Global Indicator Database"
    task gid: :environment do 
      GidXmlParser.new("UNSD", "Global Indicators Database", "")
    end

    desc "tests the country names of Global Indicator Database"
      task gid_test_countries: :environment do
      TestCountryNamesParser.new("UNSD", "Global Indicators Database", "")
    end

    desc "seeds the country names of Global Indicator Database"
      task gid_seed_countries: :environment do
      SeedCountryNamesParser.new("UNSD", "Global Indicators Database", "")
    end
  end

  namespace :wb do
    desc "parse World Development Indicators"
    task wdi: :environment do
      WdiXmlParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end

    desc "tests the country names for wdi"
    task wdi_test_countries: :environment do
      TestCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end

    desc "seeds the country names for wdi"
    task wdi_seed_countries: :environment do
      SeedCountryNamesParser.new("WB", "World Development Indicators", "footnoteSeqID")
    end
  end

  namespace :itu do
    desc "parse World Telecommunitcation and ICT Indicators Database"
    task wtiid: :environment do
      WtiidXmlParser.new("ITU", "World Telecommunication and ICT Indicators Database", "footnoteSeqID")
    end

    desc "tests the country names for wtiid"
    task wtiid_test_countries: :environment do
      TestCountryNamesParser.new("ITU", "World Telecommunication and ICT Indicators Database", "footnoteSeqID")
    end

    desc "seed the country names for wtiid"
    task wtiid_seed_countries: :environment do
      SeedCountryNamesParser.new("ITU", "World Telecommunication and ICT Indicators Database", "footnoteSeqID")
    end
  end

  namespace :unfccc do
    desc "parse Greenhouse Gas Inventory Data"
    task ggid: :environment do
      GgidXmlParser.new("UNFCCC", "Greenhouse Gas Inventory Data", "none")
    end

    desc "tests the country names for Greenhouse Gas Inventory Data"
    task ggid_test_countries: :environment do
      TestCountryNamesParser.new("UNFCCC", "Greenhouse Gas Inventory Data", "none")
    end

    desc "seeds the country names for Greenhouse Gas Inventory Data"
    task ggid_seed_countries: :environment do
      SeedCountryNamesParser.new("UNFCCC", "Greenhouse Gas Inventory Data", "none")
    end
  end
end
