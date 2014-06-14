json.array!(@students) do |student|
  json.extract! student, :email, :firstname, :lastname, :semester, :academic_program_id, :birthday, :graduation_id, :additional_information, :homepage, :github, :facebook, :xing, :linkedin, :visibility_id
  json.url student_url(student, format: :json)
end
