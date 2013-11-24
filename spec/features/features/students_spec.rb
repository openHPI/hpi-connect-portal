
require 'spec_helper'

describe "the profile page" do

	before(:each) do
    @student = FactoryGirl.create(:student, first_name:"Teststudent")
  	end

  it "should view all details of a student" do
    visit students_path
    page.should have_content(
      @student.first_name,
      @student.last_name
    )
  end

    it "should contain a link for editing a profile and it should lead to the edit page " do
    visit students_path
    find_link("Edit").click
    current_path.should_not == students_path
    current_path.should == edit_student_path(@student)
  end
  

end


describe "the students editing page" do

	before(:each) do
    @student = FactoryGirl.create(:student, first_name:"Teststudent")
  	end

	it "should contain all attributes of a student and a text field " do
    visit edit_student_path(@student)
     page.should have_content(
    "First name",
     "Last name"
    )
     #fill_in ':last_name', with: 'NewName'
  end


end

