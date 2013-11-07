module V1
	class OrganizationsController < ApplicationController
	  before_filter :authenticate_app

		def index
			@organizations = Organization.all

			respond_to do |format|
				format.json { render json: @organizations.map {|organization| organization.as_json(except: [:id, :country_ids]) }}
				format.xml { render xml: @organizations.to_xml(except: [:id, :country_ids]) }
			end

		rescue
	  	head :not_found
		end
		
	end
end
