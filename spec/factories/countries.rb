FactoryGirl.define do
  factory :country do
  	name "USA"
  end

  factory :country_with_organizations, parent: :country do
  	after(:create) do |country|
	  	3.times do
	  		organization = create(:organization)
	  		country.organizations << organization
	  	end
	  end
  end

  factory :country_with_datasets, parent: :country do
  	after(:create) do |country|
  	  3.times do
  		  dataset = create(:dataset)
  		  country.datasets << dataset
  		end
  	end
  end

  factory :country_with_records, parent: :country do
    after(:create) do |country|
      3.times do
        dataset = create(:dataset)
        create :record, country: country, dataset: dataset
      end
    end
  end
end
