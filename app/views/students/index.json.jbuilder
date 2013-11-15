json.array!(@students) do |student|
  json.extract! student, :first_name, :last_name, :semester, :academic_program, :birthday, :education, :additional_information, :homepage, :github, :facebook, :xing, :linkedin
  json.url student_url(student, format: :json)
end
