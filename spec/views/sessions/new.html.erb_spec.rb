require 'spec_helper'

describe "devise/sessions/new" do

  it "renders sign in form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", new_user_session_path, "post" do
      assert_select "input#url_field[name=?]", "user[identity_url]"
    end
  end
end
