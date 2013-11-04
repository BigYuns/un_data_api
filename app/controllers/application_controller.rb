class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  helper_method :authenticate_app

  def error(status, code, message)
  	render :json => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status
	end

	def create_client
	  ThreeScale::Client.new(:provider_key => ENV['PROVIDER_KEY'])		
	end

	def response_success(response)
		if response.success?
  		puts "Application authorized and hit reported!"
		else
  		puts "Error: #{response.error_message}"
  		head :unauthorized
		end
	end

	def authenticate_app
	  response = create_client.authrep(:app_id => params["app_id"], 
                     		      :app_key => params["app_key"],
                              :usage => { :hits => 1 })
	  response_success(response)
	end

end
