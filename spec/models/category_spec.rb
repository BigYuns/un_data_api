require 'spec_helper'

describe Category do
	let(:category) {build(:category )}
	let(:category_with_countries) {create(:category_with_countries)}
	let(:category_with_records) {create(:category_with_records)}

	describe "can create a new category" do

		context "with valid input" do
			
			it "should create a new category" do
				category.should be_valid
			end

			it "should have an organization" do
				category.organization.class.should eq(Organization)
			end
		end

		context "with invalid input" do

			it "should not create a category without a name" do
				build(:category, name: nil).should_not be_valid
			end

			it "should not create a category without an organization" do
				build(:category, organization: nil).should_not be_valid
			end

		end
	end

	describe "a category has many" do
		it "should have many countries" do
			countries = category_with_countries.countries
			expect(countries.first).to be_an_instance_of Country
		end
		it "should have many records" do
			records = category_with_records.records
			expect(records.first).to be_an_instance_of Record
		end
	end
end
