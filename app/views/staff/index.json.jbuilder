json.array!(@staff) do |staff|
  json.extract! staff, :email, :firstname, :lastname, :birthday, :additional_information, :homepage, :github, :facebook, :xing, :linkedin
  json.url staff_url(staff, format: :json)
end
