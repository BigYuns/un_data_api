require 'spec_helper'

describe Database do
  let(:database) {create :database}
  let(:database_with_datasets) {create :database_with_datasets}
  let(:database_with_countries) {create :database_with_countries}

  describe "can create a new database" do 
    context "with valid input" do

      it "should create a new database" do
        database.should be_valid
      end

      it "should belong to an organization" do
        expect(database.organization).to be_an_instance_of Organization 
      end

    end

    context "with invalid input" do

      it "should not create a database without a name" do
        build(:database, name: nil).should_not be_valid
      end

      it "should not create a database without an organization" do
        build(:database, organization_id: nil).should_not be_valid
      end

    end
  end

  describe "relationships" do

    it "should have many datasets" do
      datasets = database_with_datasets.datasets
      expect(datasets.first).to be_an_instance_of Dataset
    end

    it "should have many countries" do
      countries = database_with_countries.countries
      expect(countries.first).to be_an_instance_of Country      
    end

  end

end