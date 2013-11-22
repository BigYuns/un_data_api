Given(/^the following records:$/) do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:record, hash)
  end
end