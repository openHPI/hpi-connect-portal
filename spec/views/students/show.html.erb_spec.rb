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

    allow(view).to receive(:signed_in?) { false }
    allow(view).to receive(:current_user) { FactoryGirl.create(:user) }
    allow(view).to receive(:can?) { true }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(@student.user.firstname)
    expect(rendered).to match(@student.user.lastname)
    expect(rendered).to match(@student.semester.to_s)
    expect(rendered).to match(Student::ACADEMIC_PROGRAMS[@student.academic_program_id].capitalize)
    expect(rendered).to match(@student.additional_information)
    expect(rendered).to match(@student.homepage)
    expect(rendered).to match(@student.github)
    expect(rendered).to match(@student.facebook)
    expect(rendered).to match(@student.xing)
    expect(rendered).to match(@student.linkedin)
  end
end
