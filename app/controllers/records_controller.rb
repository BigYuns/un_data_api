class RecordsController < ApplicationController
	def index
		country = Country.find_by_name(params[:country])
		records = Category.find_by_name(params[:category]).records.where(country_id: country.id).all
		render json: records
	end
end