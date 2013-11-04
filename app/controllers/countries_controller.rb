class CountriesController < ApplicationController
	before_filter :authenticate_app

	def index
		countries = Category.find_by_name(params[:category]).countries

		render json: countries.map {|country| country.as_json(only: :name)}
	rescue
  	error(404, 404, "record does not exist")
	end
	
end