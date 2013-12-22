FactoryGirl.define do
  factory :organization do |f|
    name "WHO"
  end

  factory :organization_with_datasets, parent: :organization do
    after(:create) do |organization|
      3.times do
        create :dataset, organization: organization
      end
    end	
  end

  factory :organization_with_countries, parent: :organization do
    after(:create) do |organization|
      country_names = ["USA", "Angola", "Peru"]
      3.times do
        country_name = country_names.pop
        country = create(:country, name: country_name) 
        organization.countries << country
      end
    end
  end

  factory :organization_with_databases, parent: :organization do
    after(:create) do |organization|
      database_names = ["Environment", "Agriculture", "Health"]
      3.times do
        database_name = database_names.pop
        database = create(:database, name: database_name)
        organization.databases << database
      end 
    end
  end	
end