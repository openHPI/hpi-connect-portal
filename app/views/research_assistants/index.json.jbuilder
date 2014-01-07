json.array!(@research_assistants) do |research_assistant|
  json.extract! research_assistant, :id
  json.url research_assistant_url(research_assistant, format: :json)
end
