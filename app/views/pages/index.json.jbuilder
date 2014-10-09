json.array!(@pages) do |page|
  json.extract! page, :id, :title, :body, :meta_title, :meta_description
  json.url page_url(page, format: :json)
end
