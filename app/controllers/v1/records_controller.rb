module V1
	class RecordsController < ApplicationController
	  
		def index
			country = Country.find_by_name(params[:country]) 
			dataset = Dataset.find_by_name(params[:dataset]) 
	  	records = Record.where(dataset_id: dataset.id, country_id: country.id).all

	  	respond_to do |format|
				format.json { render json: records.map {|record| record.as_json(except: [:id, :country_id, :dataset_id])} }
				format.xml { render xml: records.to_xml(except: [:id, :country_id, :dataset_id]) }
			end
			
		rescue
			error(404, 404, "record does not exist")	
		end
		
	end
end