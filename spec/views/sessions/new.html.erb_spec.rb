require 'spec_helper'

describe "sessions/new" do

  it "renders sign in form" do
    render
    assert_select "form[method=?]", "post" do
      assert_select "input#session_email[name=?]", "session[email]"
      assert_select "input#session_password[name=?]", "session[password]"
    end
  end
end
