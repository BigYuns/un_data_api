class CategoriesController < ApplicationController
	before_filter :authenticate_app

	def index
		organization = Organization.find_by_name(params[:organization])
		categories = organization.categories
		render json: categories.map { |category| category.as_json(only: :name)}
	rescue
  	error(404, 404, "record does not exist")			
	end

end