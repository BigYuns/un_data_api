def path_to(page_name)
	case page_name

	when /\/organizations/
		get organizations_path(:json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/datasets/
		get datasets_path("WHO", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/countries/
		get countries_path("WHO", "Health", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/dataset\/country\/records/
		get records_path("WHO", "Health", "USA", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	end
end