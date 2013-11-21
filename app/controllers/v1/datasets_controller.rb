module V1
	class DatasetsController < ApplicationController

		def organization_datasets
			organization = Organization.find_by_name(params[:organization])
			datasets = organization.datasets
			
			datasets.map! { |dataset| dataset.serializable_hash(except: [:id, :country_ids, :organization_id]) } 
			respond_with(datasets)

		rescue
			error(404, 404, "record does not exist")	
		end

		def country_datasets
			organization = Organization.find_by_name(params[:organization])
			country = Country.find_by_name(params[:country])
			datasets = organization.datasets.where(country_ids: country.id).all

			datasets.map! { |dataset| dataset.serializable_hash(except: [:id, :country_ids, :organization_id]) }
			respond_with(datasets)

		rescue
			error(404, 404, "record does not exist")	
		end
		
	end
end
