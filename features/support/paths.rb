def path_to(page_name)
	case page_name

	when /\/organizations.json/
		get v1_organizations_path(:json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organizations.xml/
		get v1_organizations_path(:xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/datasets.json/
		get v1_datasets_path("WHO", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/datasets.xml/
		get v1_datasets_path("WHO", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/countries.json/
		get v1_countries_path("WHO", "Health", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/countries.xml/
		get v1_countries_path("WHO", "Health", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/country\/records.json/
		get v1_records_path("WHO", "Health", "USA", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/country\/records.xml/
		get v1_records_path("WHO", "Health", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/country\/datasets.json/
		get v1_country_datasets_path("WHO", "USA", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/country\/datasets.xml/
		get v1_country_datasets_path("WHO", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	end
end