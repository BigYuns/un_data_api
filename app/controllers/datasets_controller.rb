class DatasetsController < ApplicationController
	before_filter :authenticate_app

	def index
		organization = Organization.find_by_name(params[:organization])
		datasets = organization.datasets
		render json: datasets.map { |dataset| dataset.as_json(only: :name)}
	rescue
  	error(404, 404, "record does not exist")			
	end

end