class CategoriesController < ApplicationController

	def index
		organization = Organization.find_by_name(params[:organization])
		categories = organization.categories

		render json: categories


	rescue
  	error(404, 404, "record does not exist")			
	end

end