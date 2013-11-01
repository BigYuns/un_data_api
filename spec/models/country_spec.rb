require 'spec_helper'

describe Country do
  let(:country) {build(:country)}
  let(:country_with_organizations) {create(:country_with_organizations)}
  let(:country_with_categories) {create(:country_with_categories)}
  let(:country_with_records) {create(:country_with_records)}

	describe "can create a new country" do

		context "with valid input" do
			
			it "should create a new country" do
				country.should be_valid
			end
		end

		context "with invalid input" do

			it "should not create a category without a name" do
				build(:country, name: nil).should_not be_valid
			end
		end
	end

	describe "a country has many" do

		it "should have many organizations" do
			organizations = country_with_organizations.organizations
			expect(organizations.first).to be_an_instance_of Organization
		end

		it "should have many categories" do
			categories = country_with_categories.categories
			expect(categories.first).to be_an_instance_of Category
		end

		it "should have many records" do
			records = country_with_records.records
			expect(records.first).to be_an_instance_of Record
		end
	end
end
