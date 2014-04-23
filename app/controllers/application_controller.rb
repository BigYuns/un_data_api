class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  rescue_from MongoMapper::DocumentNotFound, with: :document_not_found
  rescue_from NoMethodError, with: :invalid_request

  before_filter :authenticate_app, :default_format_json, :set_access_control_headers
  respond_to :json, :xml

  def  set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def create_client
    @@threescale_client ||= ThreeScale::Client.new(:provider_key => ENV['PROVIDER_KEY'])		
  end

  def authenticate_app
    response = create_client.authrep(:app_id => params["app_id"], 
                                     :app_key => params["app_key"],
                                     :usage => { params[:metric].to_sym => 1 })
    response_success(response)
  end

  def response_success(response)
    if response.success?
      return true
    else
      analyze_error(response)
    end
  end

  def default_format_json
    request.format = "json" unless params[:format]
  end

  def error_report(error)
    create_client.report({:app_id => params["app_id"], :usage => {error.to_sym => 1}})
  end

  def invalid_request
    error(404, 404, "Invalid URL")
    error_report("invalid_url")
  end

  private

  def document_not_found
    error(404, 404, "Record does not exist")
    error_report("no_record_found")
  end

  def error(status, code, message)
    default_format_json
    response = { :response_type => "ERROR", :response_code => code, :message => message, :status => status } 
    undata_respond_with(response)
  end

  def undata_respond_with(item)
    respond_with do |format|
      format.json { render :json => item, :callback => params[:callback] }
      format.xml  { render :xml => item }
    end
  end

  def analyze_error(response)
    if response.error_code == "metric_invalid"
      error(response.error_code, 401, "#{response.error_message} or have you generated your metrics yet? 
                                      If you have implemented 3scale and have not added metrics run 
                                      'rake metrics:generate_metrics'. If you have added some metrics but 
                                      not the ones implemented in the project run 'rake metrics:add_metrics' ")
    else
      error(response.error_code, 401, response.error_message )
    end
  end
  
end
