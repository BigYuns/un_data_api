def path_to(page_name)
	case page_name

	when /\/organizations/
		get organizations_path

	when /\/organization\/categories/
		get "/WHO/categories"

	end
end