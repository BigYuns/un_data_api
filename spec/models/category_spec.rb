require 'spec_helper'

describe Category do
	let(:category) {build(:category )}

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
end
