module V1
	class CountriesController < ApplicationController

		def index
			countries = Dataset.find_by_name(params[:dataset]).countries

			countries.map! { |country| country.serialize_hash } 
			respond_with(countries)

		rescue
	  	error(404, 404, "record does not exist")	
		end
		
	end
end
