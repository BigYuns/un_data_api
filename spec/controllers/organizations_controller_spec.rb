require 'spec_helper'

describe OrganizationsController do

	describe "GET #index" do
		it "populates and array of organizations" do
			organization = create(:organization)
			get :index, :format => :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY']
			assigns(:organizations).should eq([organization])
		end

		it "it should respond in json" do
			get :index, :format => :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY']
			response["Content-Type"].should =~ /json/
		end
	end
end