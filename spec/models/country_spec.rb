require 'spec_helper'

describe Country do
  let(:country) {build(:country)}

	describe "can create a new country" do

		context "with valid input" do
			
			it "should create a new country" do
				country.should be_valid
			end

			it "should have an organization" do
				country.organization.class.should eq(Organization)
			end
		end

		context "with invalid input" do

			it "should not create a category without a name" do
				build(:country, name: nil).should_not be_valid
			end

			it "should not create a category without an organization" do
				build(:country, organization: nil).should_not be_valid
			end

		end
	end
end
