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

  factory :country_with_categories, parent: :country do
  	after(:create) do |country|
  	  3.times do
  		  category = create(:category)
  		  country.categories << category
  		end
  	end
  end

  factory :country_with_records, parent: :country do
    after(:create) do |country|
      3.times do
        category = create(:category)
        create :record, country: country, category: category
      end
    end
  end
end
