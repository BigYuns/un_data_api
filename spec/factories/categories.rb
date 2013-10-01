# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
  	name "Health"
  	organization
  end

  factory :category_with_countries, parent: :category do 
  	after(:create) do |category|
  		3.times do 
  			country = create(:country)
  			category.countries << country
  		end
  	end
  end
end
