class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  helper_method :authenticate_app

  def error(status, code, message)
  	respond_to do |format|
  	  format.json { render :json => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status }
  	  format.xml { render :xml => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status }
  	end
	end

	def create_client
	  ThreeScale::Client.new(:provider_key => ENV['PROVIDER_KEY'])		
	end

	def response_success(response)
		if response.success?
  		puts "Application authorized and hit reported!"
		else
  		puts "Error: #{response.error_message}"
  		error(401, 401, "app_id or app_key invalid, action requires authentication")
		end
	end

	def authenticate_app
	  response = create_client.authrep(:app_id => params["app_id"], 
                     		      :app_key => params["app_key"],
                              :usage => { :hits => 1 })
	  response_success(response)
	end

end
