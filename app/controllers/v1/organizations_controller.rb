module V1
  class OrganizationsController < ApplicationController

    def index
      organizations = Organization.all

      organizations.map! { |organization| organization.serializable_hash }

      respond_with(organizations)
    end

  end
end
