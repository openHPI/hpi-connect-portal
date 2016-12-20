require 'rails_helper'

describe ApplicationHelper do
  describe "sanitize_html" do
    it "removes tags like <script> from html strings" do
      script_string = "<script> alert('I am a malicious script.'); </script>"
      expect(sanitized_html(script_string)).not_to include "<script>"
    end
  end
end