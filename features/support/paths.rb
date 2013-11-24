def path_to(page_name)
	case page_name

	when /^\/organizations$/
		get organizations_path("app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/organizations\?format=xml$/
		get organizations_path(:xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/datasets$/
		get organization_datasets_path("WHO", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/datasets\?format=xml$/
		get organization_datasets_path("WHO", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Health\/countries$/
		get dataset_countries_path("WHO", "Health", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Health\/countries\?format=xml$/
		get dataset_countries_path("WHO", "Health", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Health\/USA\/records$/
		get country_records_path("WHO", "Health", "USA", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Health\/USA\/records\?format=xml$/
		get country_records_path("WHO", "Health", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/USA\/datasets$/
		get country_datasets_path("WHO", "USA", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/USA\/datasets\?format=xml$/
		get country_datasets_path("WHO", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	end
end