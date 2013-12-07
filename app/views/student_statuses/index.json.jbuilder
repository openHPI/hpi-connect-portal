json.array!(@student_statuses) do |student_status|
  json.extract! student_status, :description
  json.url student_status_url(student_status, format: :json)
end
