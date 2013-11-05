class RecordsController < ApplicationController
  before_filter :authenticate_app
  
	def index
		country = Country.find_by_name(params[:country]) 
		dataset = Dataset.find_by_name(params[:dataset]) 
  	records = Record.where(dataset_id: dataset.id, country_id: country.id).all
		render json: records.map {|record| record.as_json(except: [:id, :country_id, :dataset_id])}
	rescue
  	error(404, 404, "record does not exist")
	end
	
end