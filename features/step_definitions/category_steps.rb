Given(/^the following organizations:$/) do |table|
   table.hashes.each do |hash|
     organization = FactoryGirl.create(:organization, hash)
     category = FactoryGirl.create(:category)
     organization.categories << category
     category.countries << FactoryGirl.create(:country)
  end
end

