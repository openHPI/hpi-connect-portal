require 'spec_helper'
# The Studen new page is currently not aviable
# describe "students/new" do
#   before(:each) do
#     assign(:student, stub_model(Student,
#       :first_name => "MyString",
#       :last_name => "MyString",
#       :semester => 1,
#       :academic_program => "MyString",
#       :education => "MyText",
#       :additional_information => "MyText",
#       :homepage => "MyString",
#       :github => "MyString",
#       :facebook => "MyString",
#       :xing => "MyString",
#       :linkedin => "MyString"
#     ).as_new_record)
#   end

#   it "renders new student form" do
#     render

#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form[action=?][method=?]", students_path, "post" do
#       assert_select "input#student_first_name[name=?]", "student[first_name]"
#       assert_select "input#student_last_name[name=?]", "student[last_name]"
#       assert_select "input#student_semester[name=?]", "student[semester]"
#       assert_select "input#student_academic_program[name=?]", "student[academic_program]"
#       assert_select "textarea#student_education[name=?]", "student[education]"
#       assert_select "textarea#student_additional_information[name=?]", "student[additional_information]"
#       assert_select "input#student_homepage[name=?]", "student[homepage]"
#       assert_select "input#student_github[name=?]", "student[github]"
#       assert_select "input#student_facebook[name=?]", "student[facebook]"
#       assert_select "input#student_xing[name=?]", "student[xing]"
#       assert_select "input#student_linkedin[name=?]", "student[linkedin]"
#     end
#   end
# end
