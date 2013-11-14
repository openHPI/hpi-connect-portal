json.array!(@languages) do |language|
  json.extract! language, :name
  json.url language_url(language, format: :json)
end
