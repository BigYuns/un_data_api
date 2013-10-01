require 'spec_helper'

describe Record do
	let(:record) {create(:record)}

	describe "creating a new record" do

		context "with valid input" do

			it "should create a new record" do
				record.should be_valid
			end
		end

		context "attributes" do

			it "should have a year" do
				puts record.year.class
				expect(record.year).to be_an_instance_of Fixnum
			end

			it "should have a value" do
				expect(record.value).to be_an_instance_of Float
			end

			it "should have a measurement" do
				expect(record.measurement).to be_an_instance_of String
			end

			it "should belong to a category" do
				expect(record.category).to be_an_instance_of Category
			end

			it "should belong to a country" do
				expect(record.country).to be_an_instance_of Country
			end

		end

		context "with invalid input" do

			it "should not create without a year" do
				build(:record, year: nil).should_not be_valid
			end

			it  "should not create without a value" do
				build(:record, value: nil).should_not be_valid
			end

			it "should not create without a measurement" do
				build(:record, measurement: nil).should_not be_valid
			end
		end
	end
end
