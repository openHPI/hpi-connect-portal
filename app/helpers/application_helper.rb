module ApplicationHelper

  def label_field(form, field, name)
    form.label(field, name, class: "control-label") << mark_if_required(form.object, field)
  end

  def mark_if_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveRecord::Validations::PresenceValidator
  end

  def sanitized_html(text)
    Sanitize.fragment(text.html_safe,
      elements: ['ul', 'li', 'b', 'strong', 'em', 'u', 'i', 'table', 'tbody', 'tr', 'td', 'caption', 'ol', 'blockquote', 'div', 'span',
        'br', 'a','p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'],
      attributes: {'a' => ['target', 'href'], 'span' => ['class'], 'table'=>['border', 'cellspacing', 'cellpadding'], all: ['style']},
      protocols: {'a' => {'href' => ['http', 'https', 'mailto']}},
      css: { properties: ['text-align','text-decoration', 'padding-left', 'color', 'background-color', 'width', 'height', 'border-color', 'list-style-type']}).html_safe
  end
end
