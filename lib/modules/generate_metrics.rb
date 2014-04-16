class GenerateMetrics
  include HTTParty
  base_uri @three_scale_url

  def initialize(three_scale_url)
    @hit_methods_array = ["organizations",
                          "organization_datasets",
                          "countries",
                          "records",
                          "country_datasets",
                          "databases",
                          "db_datasets",
                          "db_countries",
                          "db_records",
                          "db_country_datasets"]

    @other_metrics_array = ["invalid_url", "no_record_found"]
    @three_scale_url = three_scale_url
  end

  def get_service_id
    @provider_key_query = { query: { provider_key: ENV['PROVIDER_KEY'] } }
    response = self.class.get('/admin/api/services.xml', @provider_key_query )
    data = response.parsed_response
    @service_id = data['services']['service']['id']
  end

  def get_metric_list
    response = self.class.get('/admin/api/services/' + @service_id + '/metrics.xml', @provider_key_query)
    data = response.parsed_response
    @hits_metric_id = data['metrics']['metric']['id']
    create_hits_method
  end

  def create_hits_method
    path = '/admin/api/services/' + @service_id + '/metrics/' + @hits_metric_id + '/methods.xml'
    @hit_methods_array.each do |method|
      self.class.post(path, body: { provider_key: ENV['PROVIDER_KEY'], friendly_name: method, system_name: method, unit: 'hits' })
    end 
  end

  def create_metrics
    path = '/admin/api/services/' + @service_id + '/metrics.xml'
    @other_metrics_array.each do |metric|
      self.class.post(path, body: { provider_key: ENV['PROVIDER_KEY'], friendly_name: metric, system_name: metric, unit: 'hits' })
    end
  end

end