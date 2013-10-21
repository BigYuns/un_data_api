Given(/^the following organizations:$/) do |table|
   table.hashes.each do |hash|
  	 FactoryGirl.create(:organization, hash)
  end
end

