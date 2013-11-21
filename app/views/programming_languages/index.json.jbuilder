json.array!(@programming_languages) do |programming_language|
  json.extract! programming_language, :name
  json.url programming_language_url(programming_language, format: :json)
end
