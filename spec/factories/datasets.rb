# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dataset do
  	name "Health"
  	organization
  end

  factory :dataset_with_countries, parent: :dataset do 
  	after(:create) do |dataset|
  		3.times do 
  			country = create(:country)
  			dataset.countries << country
  		end
  	end
  end

  factory :dataset_with_records, parent: :dataset do
    after(:create) do |dataset|
      3.times do
        country = create(:country)
        create :record, dataset: dataset, country: country
      end
    end
  end
end
