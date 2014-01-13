require 'spec_helper'

describe "the students page" do

  let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
  let(:staff_role) { FactoryGirl.create(:role, name: 'Staff', level: 2) }
  let(:staff) { FactoryGirl.create(:user, role: staff_role) }

	before(:each) do
    @programming_language = FactoryGirl.create(:programming_language)

    @student1 = FactoryGirl.create(:user,
            :role => student_role,
            :programming_languages =>[@programming_language]
            )

    login_as(staff, :scope => :user)
    visit students_path

  end

  it "should view only names and status of a student on the overview" do
    page.should have_content(
      @student1.firstname,
      @student1.lastname,
      @student1.semester
    )
  end

  it "should contain a link for showing a profile and it should lead to profile page " do
    find_link(@student1.firstname).click
    
    current_path.should_not == students_path
    current_path.should == student_path(@student1)
  end

  # it "should delete the first student if Delete is clicked " do
  #   visit students_path
  #   #find_link("Destroy").click
  #   (find_link('Destroy')[:href].should == student_path(@student1))
  #  page.should have_xpath("//a[@href => 'students/1/edit']")
  #  page.find(:xpath, "/html/body/div[2]/div/div[2]/table/tbody/tr[1]/td[15]/a").click

  #   current_path.should == students_path
  #  expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"       
    
  # end

end

describe "the students editing page" do

  let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }

  before(:each) do
    @student1 = FactoryGirl.create(:user,
            :role => student_role
            )
    login_as(@student1, :scope => :user)
  end

	it "should contain all attributes of a student" do
    visit edit_student_path(@student1)
    page.should have_content(
      "Career",
      "General Information"
    )

  end

  it "should be possible to change attributes of student1 " do
    visit edit_student_path(@student1)
    fill_in 'user_facebook', :with => 'www.faceboook.com/alex'
    fill_in 'user_email', :with => 'www.alex@hpi.uni-potsdam.de'
   
    find('input[type="submit"]').click
  
    current_path.should == student_path(@student1)

    page.should have_content(
      "User was successfully updated",
      "General information",
      "www.alex@hpi.uni-potsdam.de"
    )
    
end

# to implement:
  # it "should not be possible to change the name of  a student " do
  #   visit edit_student_path(@student1)
  #   fill_in 'user_firstname', :with => 'Agathe'
  #   fill_in 'user_lastname', :with => 'Ackermann'
  #   find('input[type="submit"]').click
  

  #   page.should have_content(
  #   "error",
   
  #   )
  #    #fill_in ':lastname', with: 'NewName'

  # end

end

describe "the students profile page" do

  let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }

  before(:each) do
    @student1 = FactoryGirl.create(:user,
            :role => student_role)

     @student2 = FactoryGirl.create(:user,
            :role => student_role)
  end


  it "should contain all the details of student1" do
      visit student_path(@student1)
      page.should have_content(
        @student1.firstname,
        @student1.lastname
      )
  end


  it "should contain all the details of student2" do
      visit student_path(@student2)
      page.should have_content(
        @student2.firstname,
        @student2.lastname
      )

  end

  it "should have an edit link on the show page of the own profile which leads to the students edit page" do
      login_as(@student1, :scope => :user)
      visit student_path(@student1)
      page.find_link('Edit').click
      page.current_path.should == edit_student_path(@student1)
  end

  it "should not have an edit link on the show page of someone elses profile" do
      login_as(@student1, :scope => :user)
      visit student_path(@student2)
      should_not have_link('Edit')
  end

end