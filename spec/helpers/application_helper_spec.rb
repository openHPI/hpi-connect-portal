require 'spec_helper'

describe ApplicationHelper do
  describe "sanitize_html" do
    it "removes tags like <script> from html strings" do
      script_string = "<script> alert('I am a malicious script.'); </script>"
      sanitized_html(script_string).should_not include "<script>"
    end
  end
end