require 'spec_helper'

describe Organization do

	let(:organization) {build(:organization)}
	let(:organization_with_datasets) {create(:organization_with_datasets)}
	let(:organization_with_countries) {create(:organization_with_countries)}

	describe "can create a new organization" do

		context "with valid input" do
			
			it "should create a new organization" do
				organization.should be_valid
			end

		end

		context "with invalid input" do

			it "should not create an organization without a title" do
				build(:organization, name: nil).should_not be_valid
			end

		end
		
	end

	describe "organizations should have many" do

		it "should have many datasets" do
			datasets = organization_with_datasets.datasets
			expect(datasets.first).to be_an_instance_of Dataset
		end

		it "should have many countries" do
			countries = organization_with_countries.countries
			expect(countries.first).to be_an_instance_of Country			
		end

	end

end