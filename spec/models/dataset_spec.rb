require 'spec_helper'

describe Dataset do
  let(:dataset) {build(:dataset)}
  let(:dataset_with_countries) {create(:dataset_with_countries)}
  let(:dataset_with_records) {create(:dataset_with_records)}

  describe "can create a new dataset" do

    context "with valid input" do
      it "should create a new dataset" do
        dataset.should be_valid
      end 

      it "should have an organization" do
        dataset.organization.class.should eq(Organization)
      end
    end

    context "with invalid input" do
      it "should not create a dataset without a name" do
        build(:dataset, name: nil).should_not be_valid
      end

      it "should not create a dataset without an organization" do
        build(:dataset, organization: nil).should_not be_valid
      end
    end

  end

  describe "a dataset has many" do

    it "should have many countries" do
      countries = dataset_with_countries.countries
      expect(countries.first).to be_an_instance_of Country
    end
    it "should have many records" do
      records = dataset_with_records.records
      expect(records.first).to be_an_instance_of Record
    end
    
  end 
end
