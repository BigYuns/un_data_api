def path_to(page_name)
	case page_name

	when /\/organizations/
		get organizations_path(:json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/categories/
		get categories_path("WHO", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/category\/countries/
		get countries_path("WHO", "Health", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	when /\/organization\/category\/country\/records/
		get records_path("WHO", "Health", "USA", :json, "app_id" => ENV['APP_ID'], "app_key" => ENV['APP_KEY'])

	end
end