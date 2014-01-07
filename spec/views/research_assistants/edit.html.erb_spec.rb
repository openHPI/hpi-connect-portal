require 'spec_helper'

describe "research_assistants/edit" do
  before(:each) do
    @user = assign(:users, stub_model(User,
      :firstname => "MyString",
      :lastname => "MyString",
      :user_status_id => 1,
      :email => "MyString@example.com",
      :birthday => "2014-01-10",
      :additional_information => "MyText",
      :homepage => "MyString",
      :github => "MyString",
      :facebook => "MyString",
      :xing => "MyString",
      :linkedin => "MyString",
    ))
  end

  it "renders the edit research_assistant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", research_assistant_path(@user.id), "post" do
      assert_select "input#user_email[name=?]", "user[email]"
      assert_select "select#user_user_status_id[name=?]", "user[user_status_id]"
      assert_select "input#user_birthday[name=?]", "user[birthday]"
      assert_select "input#user_photo[name=?]", "user[photo]"
      assert_select "input#user_cv[name=?]", "user[cv]"
      assert_select "textarea#user_additional_information[name=?]", "user[additional_information]"
      assert_select "input#user_homepage[name=?]", "user[homepage]"
      assert_select "input#user_github[name=?]", "user[github]"
      assert_select "input#user_facebook[name=?]", "user[facebook]"
      assert_select "input#user_xing[name=?]", "user[xing]"
      assert_select "input#user_linkedin[name=?]", "user[linkedin]"
    end
  end
end
