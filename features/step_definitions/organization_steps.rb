Given(/^I ask for JSON$/) do
  header 'Accept', 'application/json'
end

Given(/^I ask for XML$/) do
  header 'Accept', 'application/xml'
end

Given(/^the WHO USA Health data exists$/) do
  FactoryGirl.create(:record)
end

When(/^I send a GET request to "(.*?)"$/) do |path|
  path_to(path)
end

Then(/^the response body should be a JSON representation of the (\w+)$/) do |model|
  last_response.body.should
  eq(model.constantize.last.to_json)
end

Then(/^the response body should be a xml representation of the (\w+)$/) do |model|
  last_response.body.should
  eq(model.constantize.last.to_xml)
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


