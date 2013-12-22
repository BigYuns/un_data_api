require 'spec_helper'

describe Record do
  let(:record) {create(:record)}
  let(:record_with_footnotes) {create(:record_with_footnotes)}
  let(:footnote) {create(:footnote)}

  describe "creating a new record" do
    context "with valid input" do
      it "should create a new record" do
        record.should be_valid
      end
    end

    context "attributes" do
      it "should have a year" do
        expect(record.year).to be_an_instance_of Fixnum
      end

      it "should have a value" do
        expect(record.value).to be_an_instance_of Float
      end

      it "should have a measurement" do
        expect(record.measurement).to be_an_instance_of String
      end

      it "should belong to a dataset" do
        expect(record.dataset).to be_an_instance_of Dataset
      end

      it "should belong to a country" do
        expect(record.country).to be_an_instance_of Country
      end

      it "should have an array of footnote ids" do
        expect(record.footnotes).to be_an_instance_of Array
      end
    end

    context "with invalid input" do
      it "should not create without a year" do
        build(:record, year: nil).should_not be_valid
      end

      it "should not create without a value" do
        build(:record, value: nil).should_not be_valid
      end

      it "should not create without a measurement" do
        build(:record, measurement: nil).should_not be_valid
      end
    end

    context "add footnotes to record" do
      it "should be able to add a footnote to the record" do
        record.footnotes << footnote
        expect(record.footnotes.last).to eq(footnote)
      end
    end
    
  end
end
