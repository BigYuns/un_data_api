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

	###Database Paths

	when /^\/WHO\/databases$/
		get databases_path("WHO", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/databases\?format=xml$/
		get databases_path("WHO", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/database_datasets$/
		get db_datasets_path("WHO", "Environment Statistics Database", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/database_datasets\?format=xml$/
		get db_datasets_path("WHO", "Environment Statistics Database", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/Health\/countries$/
		get db_dataset_countries_path("WHO", "Environment Statistics Database", "Health", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/Health\/countries\?format=xml$/
		get db_dataset_countries_path("WHO", "Environment Statistics Database", "Health", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/Health\/USA\/records$/
		get db_country_records_path("WHO", "Environment Statistics Database", "Health", "USA", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/Health\/USA\/records\?format=xml$/
		get db_country_records_path("WHO", "Environment Statistics Database", "Health", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/USA\/datasets$/
		get db_country_datasets_path("WHO", "Environment Statistics Database", "USA", "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /^\/WHO\/Environment Statistics Database\/USA\/datasets\?format=xml$/
		get db_country_datasets_path("WHO", "Environment Statistics Database", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	end
end