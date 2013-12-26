module V1
  class CountriesController < ApplicationController

    def index
      countries = Dataset.find_by_name!(params[:dataset]).countries

      countries.map! { |country| country.serializable_hash } 

      undata_respond_with(countries)
    end

    def database_countries
    end

  end
end
