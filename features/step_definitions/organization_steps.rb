Given(/^I send JSON$/) do
  header 'Content-Type', 'application/json'
end

When(/^I send a GET request to "(.*?)"$/) do |path|
	get path
end

Then(/^the response status should be "(.*?)"$/) do |status|
	last_response.status.should eq(status.to_i)
end

Then(/^the response body should be a JSON representation of the (\w+)$/) do |model|
	last_response.body.should
	eq(model.constantize.last.to_json)
end