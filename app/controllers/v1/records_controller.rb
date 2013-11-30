module V1
  class RecordsController < ApplicationController

    def index
      country = Country.find_by_name!(params[:country]) 
      dataset = Dataset.find_by_name!(params[:dataset]) 
      records = Record.where(dataset_id: dataset.id, country_id: country.id).all

      records.map! { |record| record.serializable_hash }

      respond_with(records)
    end

  end
end