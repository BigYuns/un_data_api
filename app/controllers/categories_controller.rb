class CategoriesController < ApplicationController

	def index
		organization = Organization.find_by_name(params[:organization])
		categories = organization.categories

		render json: categories			
	end

end