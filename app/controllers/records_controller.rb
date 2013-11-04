class RecordsController < ApplicationController
  before_filter :authenticate_app
  
	def index
		country = Country.find_by_name(params[:country]) 
		category = Category.find_by_name(params[:category]) 
  	records = Record.where(category_id: category.id, country_id: country.id).all
		render json: records
	rescue
  	error(404, 404, "record does not exist")
	end
	
end