module V1
	class CountriesController < ApplicationController
		before_filter :authenticate_app

		def index
			countries = Dataset.find_by_name(params[:dataset]).countries

			respond_to do |format|
				format.json { render json: countries.map { |country| country.as_json(except: [:id, :dataset_ids, :organization_ids]) } }
				format.xml { render xml: countries.to_xml(except: [:id, :dataset_ids, :organization_ids]) }
			end

		rescue
	  	error(404, 404, "record does not exist")
		end
		
	end
end
