module V1
	class DatasetsController < ApplicationController

		def organization_datasets
			organization = Organization.find_by_name!(params[:organization])
			datasets = organization.datasets
			
			datasets.map! { |dataset| dataset.serializable_hash } 

			respond_with(datasets)
		end

		def country_datasets
			organization = Organization.find_by_name!(params[:organization])
			country = Country.find_by_name(params[:country])
			datasets = organization.datasets.where(country_ids: country.id).all

			datasets.map! { |dataset| dataset.serializable_hash }

			respond_with(datasets)
		end
		
	end
end
