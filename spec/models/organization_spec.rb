require 'spec_helper'

describe Organization do
	let(:organization) {build(:organization)}

	describe "can create a new organization" do

		context "with valid input" do
			
			it "should create a new organization" do
				organization.should be_valid
			end
		end
	end
end