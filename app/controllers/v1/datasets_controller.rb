module V1
  class DatasetsController < ApplicationController

    def organization_datasets
      organization = Organization.find_by_name!(params[:organization])
      datasets = organization.datasets

      datasets.map! { |dataset| dataset.serializable_hash } 

      undata_respond_with(datasets)
    end

    def country_datasets
      organization = Organization.find_by_name!(params[:organization])
      country = Country.find_by_name(params[:country])
      datasets = organization.datasets.where(country_ids: country.id).all

      datasets.map! { |dataset| dataset.serializable_hash }

      undata_respond_with(datasets)
    end

    def database_datasets
      database = Database.find_by_name!(params[:database])
      datasets = database.datasets

      datasets.map! { |dataset| dataset.serializable_hash }

      undata_respond_with(datasets)
    end

    def database_country_datasets
      database = Database.find_by_name!(params[:database])
      country = Country.find_by_name(params[:country])
      datasets = database.datasets.where(country_ids: country.id).all

      datasets.map! { |dataset| dataset.serializable_hash }

      undata_respond_with(datasets)
    end

  end
end
