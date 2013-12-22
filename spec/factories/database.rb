FactoryGirl.define do
  factory :database do |f|
    name "Environment Statistics Database"
    organization
  end

  factory :database_with_datasets, parent: :database do
    after(:create) do |database|
      3.times do
        dataset = create(:dataset)
        database.datasets << dataset
      end
    end
  end

  factory :database_with_countries, parent: :database do
    after(:create) do |database|
      country_names = ["USA", "Angola", "Peru"]
      3.times do
        country_name = country_names.pop
        country = create(:country, name: country_name)
        database.countries << country
      end
    end
  end
end