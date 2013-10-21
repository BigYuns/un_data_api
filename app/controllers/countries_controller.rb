class CountriesController < ApplicationController
	def index
		organization = Organization.find_by_name(params[:organization])
		countries = organization.categories.where(name: params[:category]).first.countries.all
		render json: countries
	end
end