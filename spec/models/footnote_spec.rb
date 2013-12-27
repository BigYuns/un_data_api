require 'spec_helper'

describe Footnote do
  let(:footnote) {build(:footnote)}
  let(:record_with_footnotes) {create(:record_with_footnotes)}

  describe "can create a new footnote" do

    context "with valid input" do
      it "should create a new footnote" do
        footnote.should be_valid
      end
    end

    context "with invalid input" do
      it "should not create a footnote without a number" do
        build(:footnote, text: nil).should_not be_valid
      end

      it "should not create a footnote without a number" do
        build(:footnote, number: nil).should_not be_valid
      end
    end
  end
end