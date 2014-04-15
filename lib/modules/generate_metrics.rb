class GenerateMetrics
  include HTTParty
  base_uri 'undata-api-admin.3scale.net'

  def initialize
    # @hit_methods_array = ["organizations",
    #                       "organization_datasets",
    #                       "countries",
    #                       "records",
    #                       "country_datasets",
    #                       "databases",
    #                       "db_datasets",
    #                       "db_countries",
    #                       "db_records",
    #                       "db_country_datasets"]

    # @other_metrics_array = ["invalid_url", "no_record_found"]

      @hit_methods_array = ["hello"]
      @other_metrics_array = ["goodbye"]
  end

  def get_service_id
    @provider_key_query = { query: { provider_key: ENV['PROVIDER_KEY'] } }
    response = self.class.get('/admin/api/services.xml', @provider_key_query )
    data = response.parsed_response
    @service_id = data['services']['service'][0]['id']
  end

  def get_metric_list
    response = self.class.get('/admin/api/services/' + @service_id + '/metrics.xml', @provider_key_query)
    data = response.parsed_response
    @hits_metric_id = data['metrics']['metric'][0]['id']
    create_hits_method
  end

  def create_hits_method
    @hit_methods_array.each do |method|
      new_method_query = { query: { provider_key: ENV['PROVIDER_KEY'], friendly_name: method, system_name: method, unit: 'hits' } }
      self.class.post('/admin/api/' + @service_id + '/metrics/' + @hits_metric_id + '/methods.xml', new_method_query)
    end 
  end

  def create_metrics
    @other_metrics_array.each do |metric|
      new_metric_query = { query: { provider_key: ENV['PROVIDER_KEY'], friendly_name: metric, system_name: metric, unit: 'hits' } }
      self.class.post('/admin/api/' + @service_id + '/metrics/metrics.xml', new_metric_query)
    end
  end

end