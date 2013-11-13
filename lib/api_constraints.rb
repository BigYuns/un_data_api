class ApiConstraints
	def initialize(options)
		@version = options[:language]
		@default = options[:default]
	end

	def matches?(req)
		@default || req.headers['Accept'].include?("application/vnd.un_data_api.#{@version}")
	end

end