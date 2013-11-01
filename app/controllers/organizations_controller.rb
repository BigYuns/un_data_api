class OrganizationsController < ApplicationController

	def index
		@organizations = Organization.all
		render json: @organizations.map {|organization| organization.as_json(only: :name)}
	rescue
  	error(404, 404, "record does not exist")
	end
	
end