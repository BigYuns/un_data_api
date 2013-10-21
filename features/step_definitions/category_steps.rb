Given(/^the following organizations:$/) do |table|
   table.hashes.each do |hash|
     organization = FactoryGirl.create(:organization_with_categories, hash)
  end
end

