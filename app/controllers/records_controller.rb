class RecordsController < ApplicationController
  before_filter :authenticate_app
  
	def index
		country = Country.find_by_name(params[:country]) 
		category = Category.find_by_name(params[:category]) 
  	records = Record.where(category_id: category.id, country_id: country.id).all

  	respond_to do |format|
			format.json { render json: records.map {|record| record.as_json(except: [:id, :country_id, :category_id])} }
			format.xml { render xml: records.to_xml(except: [:id, :country_id, :category_id]) }
		end

	rescue
  	error(404, 404, "record does not exist")
	end
	
end