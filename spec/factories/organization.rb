FactoryGirl.define do
	factory :organization do |f|
		name "WHO"
	end

	factory :organization_with_categories, :parent => :organization do
		after(:create) do |organization|
		  3.times do
			  create :category, organization: organization
		  end
		end	
	end

	factory :organization_with_countries, :parent => :organization do
		after(:create) do |organization|
			3.times do
				country = create :country
				organization.countries << country
			end
		end
	end	
end