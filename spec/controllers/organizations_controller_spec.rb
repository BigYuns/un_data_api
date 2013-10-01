require 'spec_helper'

describe OrganizationsController do

	describe "GET #index" do
		it "populates and array of organizations" do
			organization = create(:organization)
			get :index
			assigns(:organizations).should eq([organization])
		end

		it "it should respond in json" do
			get :index, :format => :json
			response["Content-Type"].should =~ /json/
		end
	end
end