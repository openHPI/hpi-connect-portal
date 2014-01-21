json.array!(@employers) do |employer|
  json.extract! employer, :name
  json.url employer_url(employer, format: :json)
end
