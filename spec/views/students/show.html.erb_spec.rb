require 'spec_helper'

describe "students/show" do
  before(:each) do
    @student = assign(:student, FactoryGirl.create(:student, additional_information: "MyText",
      homepage: "Homepage",
      github: "Github",
      facebook: "Facebook",
      xing: "Xing",
      linkedin: "Linkedin"
    ))

    view.stub(:signed_in?) { false }
    view.stub(:current_user) { FactoryGirl.create(:user) }
    view.stub(:can?) { true }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(@student.user.firstname)
    rendered.should match(@student.user.lastname)
    rendered.should match(@student.semester.to_s)
    rendered.should match(Student::ACADEMIC_PROGRAMS[@student.academic_program_id].capitalize)
    rendered.should match(@student.additional_information)
    rendered.should match(@student.homepage)
    rendered.should match(@student.github)
    rendered.should match(@student.facebook)
    rendered.should match(@student.xing)
    rendered.should match(@student.linkedin)
  end
end
