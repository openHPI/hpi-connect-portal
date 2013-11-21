json.array!(@chairs) do |chair|
  json.extract! chair, :name
  json.url chair_url(chair, format: :json)
end
