json.array!(@user_statuses) do |user_status|
  json.extract! user_status, :description
  json.url user_status_url(user_status, format: :json)
end
