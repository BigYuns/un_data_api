def path_to(page_name)
	case page_name

	when /^\/organizations$/
		get organizations_path("app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/organizations?format=xml$/
		puts "hello"
		get organizations_path("app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/datasets/
		get organization_datasets_path("WHO", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/datasets?format=xml/
		get organization_datasets_path("WHO", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/countries/
		get dataset_countries_path("WHO", "Health", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/countries=format=xml/
		get dataset_countries_path("WHO", "Health", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/country\/records/
		get country_records_path("WHO", "Health", "USA", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/country\/records?format=xml/
		get country_records_path("WHO", "Health", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/country\/datasets/
		get country_datasets_path("WHO", "USA", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/country\/datasets?format=xml/
		get country_datasets_path("WHO", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	end
end