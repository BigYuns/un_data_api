Given(/^the following categories:$/) do |table|
	table.hashes.each do |hash|
  	category = FactoryGirl.create(:category_with_records, hash)
  end
end

