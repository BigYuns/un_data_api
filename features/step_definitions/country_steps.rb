Given(/^the following countries:$/) do |table|
	table.hashes.each do |hash|
    FactoryGirl.create(:country_with_records, hash)
	end
end