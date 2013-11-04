class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  def error(status, code, message)
  	render :json => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status
	end

	def index
		# keep your provider key secret
		client = ThreeScale::Client.new(:provider_key => ENV['PROVDER_KEY'] )

		# you will usually obtain app_id and app_key from request params
		response = client.authrep( :app_id => 'ccd7fc7e' ,
                           		 :app_key => 'a7ca9748c291f43f54c53af38afa6a65',
                               :usage => { :hits => 1 })

		if response.success?
  		puts "Application authorized and hit reported!"
		else
  		puts "Error: #{response.error_message}"
  		return
		end
	end

end
