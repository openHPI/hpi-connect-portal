json.array!(@students) do |student|
  json.extract! student, :email, :firstname, :lastname, :semester, :academic_program, :birthday, :education, :additional_information, :homepage, :github, :facebook, :xing, :linkedin
  json.url student_url(student, format: :json)
end
