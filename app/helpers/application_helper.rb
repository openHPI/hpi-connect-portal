module ApplicationHelper

  def label_field(form, field, name)
    form.label(field, name, class: "control-label") << mark_if_required(form.object, field)
  end

  def mark_if_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveRecord::Validations::PresenceValidator
  end 

  def sanitize_html(html)
    Sanitize.clean(html, 
      :elements => ['ul', 'li', 'b', 'u', 'i', 'tr', 'td', 'ol', 'blockquote', 'div', 'span', 
        'br', 'a', 'h1', 'h2', 'h3'],
      :attributes => {'a' => ['target', 'href'], 'span' => ['class']},
      :protocols => {'a' => {'href' => ['http', 'https', 'mailto']}}).html_safe
  end
end
