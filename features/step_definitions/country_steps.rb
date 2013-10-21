Given(/^the following categories:$/) do |table|
	table.hashes.each do |hash|
  	 category = FactoryGirl.create(:category, hash)
  	 category.countries << FactoryGirl.create(:country)
  end
end

Given(/^the following countries:$/) do |table|
	table.hashes.each do |hash|
		FactoryGirl.create(:country, hash)
	end
end