class CategoriesController < ApplicationController
	before_filter :authenticate_app

	def index
		organization = Organization.find_by_name(params[:organization])
		categories = organization.categories

		respond_to do |format|
			format.json { render json: categories.map { |category| category.as_json(except: [:id, :country_ids, :organization_id])} }
			format.xml { render xml: categories.to_xml(except: [:id, :country_ids, :organization_id]) }
		end

	rescue
  	error(404, 404, "record does not exist")			
	end

end