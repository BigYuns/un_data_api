Given(/^I send JSON$/) do
  header 'Content-Type', 'application/json'
end

When(/^I send a GET request to "(.*?)"$/) do |path|
	path_to(path)
end

Then(/^the response status should be "(.*?)"$/) do |status|
	begin
		last_response.status.should eq(status.to_i)
	rescue RSpec::Expectations::ExpectationNotMetError => e
		puts "Response body:"
		puts last_response.body
		raise e
	end
end

Then(/^the response body should be a JSON representation of the (\w+)$/) do |model|
	last_response.body.should
	eq(model.constantize.last.to_json)
end

Given(/^the following organizations:$/) do |table|
   table.hashes.each do |hash|
     organization = FactoryGirl.create(:organization_with_categories, hash)
  end
end


