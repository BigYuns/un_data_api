class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  rescue_from MongoMapper::DocumentNotFound, with: :document_not_found
  rescue_from NoMethodError, with: :document_not_found

  before_filter :authenticate_app, :default_format_json
  respond_to :json, :xml

	def create_client
	  ThreeScale::Client.new(:provider_key => ENV['PROVIDER_KEY'])		
	end

	def response_success(response)
		if response.success?
  		puts "Application authorized and hit reported!"
		else
  		error(response.error_code, 401, response.error_message)
		end
	end

	def authenticate_app
	  response = create_client.authrep(:app_id => params["app_id"], 
                     		      :app_key => params["app_key"],
                              :usage => { params[:metric].to_sym => 1 })
	  response_success(response)
	end

	def default_format_json
	  request.format = "json" unless params[:format]
	end


  private

  def document_not_found
    error(404, 404, "Record does not exist or invalid request")
  end

  def error(status, code, message)
    default_format_json
    response = { :response_type => "ERROR", :response_code => code, :message => message, :status => status } 
    respond_with(response)
  end

end
