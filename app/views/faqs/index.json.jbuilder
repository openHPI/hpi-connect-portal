json.array!(@faqs) do |faq|
  json.extract! student, :title, :text
  json.url faq_url(faq, format: :json)
end