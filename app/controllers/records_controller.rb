class RecordsController < ApplicationController
	def index
		country = Country.find_by_name(params[:country]) || not_found
		category = Category.find_by_name(params[:category]) || not_found

  	records = Record.where(category_id: category.id, country_id: country.id).all

		render json: records

	rescue
  	error(404, 404, "record does not exist")
	end
end