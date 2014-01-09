json.array!(@research_assistants) do |research_assistant|
  json.extract! research_assistant, :email, :firstname, :lastname, :birthday, :additional_information, :homepage, :github, :facebook, :xing, :linkedin
  json.url research_assistant_url(research_assistant, format: :json)
end
