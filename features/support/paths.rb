def path_to(page_name)
	case page_name

	when /\/organizations.json/
		get organizations_path(:json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organizations.xml/
		get organizations_path(:xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/datasets.json/
		get datasets_path("WHO", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/datasets.xml/
		get datasets_path("WHO", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/countries.json/
		get countries_path("WHO", "Health", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/countries.xml/
		get countries_path("WHO", "Health", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/country\/records.json/
		get records_path("WHO", "Health", "USA", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/country\/records.xml/
		get records_path("WHO", "Health", "USA", :xml, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	end
end