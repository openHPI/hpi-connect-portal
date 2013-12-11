require 'spec_helper'

describe "students/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :firstname => "MyString",
      :lastname => "MyString",
      :semester => 1,
      :academic_program => "MyString",
      :education => "MyText",
      :additional_information => "MyText",
      :homepage => "MyString",
      :github => "MyString",
      :facebook => "MyString",
      :xing => "MyString",
      :linkedin => "MyString",
      :is_student => true
    ))
  end

  it "renders the edit student form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", student_path(@user.id), "post" do
      assert_select "input#user_firstname[name=?]", "user[firstname]"
      assert_select "input#user_lastname[name=?]", "user[lastname]"
      assert_select "input#user_semester[name=?]", "user[semester]"
      assert_select "input#user_academic_program[name=?]", "user[academic_program]"
      assert_select "textarea#user_education[name=?]", "user[education]"
      assert_select "textarea#user_additional_information[name=?]", "user[additional_information]"
      assert_select "input#user_homepage[name=?]", "user[homepage]"
      assert_select "input#user_github[name=?]", "user[github]"
      assert_select "input#user_facebook[name=?]", "user[facebook]"
      assert_select "input#user_xing[name=?]", "user[xing]"
      assert_select "input#user_linkedin[name=?]", "user[linkedin]"
    end
  end
end
