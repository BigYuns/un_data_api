class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  def error(status, code, message)
  	render :json => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status
	end

end
