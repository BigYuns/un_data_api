module V1
  class DatabasesController < ApplicationController

    def organization_databases
      puts params[:organization]
      databases = Organization.find_by_name(params[:organization]).databases

      databases.map! { |database| database.serializable_hash }

      undata_respond_with(databases)
    end

  end
end


