
require 'spec_helper'


describe "the profile page" do


	before :all do
    @student1 = FactoryGirl.create(:student,
            :first_name => 'Alexander',
            :last_name  => 'Zeier',
            :education => 'SAP',
            :programming_languages =>[FactoryGirl.create(:programming_language)]
            )

    # @student2 = FactoryGirl.create(:student,
    #         :first_name => 'Maria',
    #         :last_name  => 'Müller',
    #         :education => 'SAP')

  end


  it "should view only names and status of a student on the overview" do
    visit students_path
    page.should have_content(
      @student1.first_name,
      @student1.last_name,
     # iteration 2: 
     #@student1.status
      # @student2.first_name,
      # @student2.last_name
     # iteration 2: 
     #@student2.status
     
    )
  end

  it "should contain a link for editing a profile and it should lead to the edit page " do
    visit students_path
    find_link("Edit").click
    current_path.should_not == students_path
    current_path.should == edit_student_path(@student1)
  end

  it "should contain a link for showing a profile and it should lead to profile page " do
    visit students_path
    find_link("Show").click
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
  #  expect(page).to have_no_content "#{@student1.first_name} #{@student1.last_name}"       
    
  # end

  
  after(:all) do
    Student.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end

  

end

 describe "the students editing page" do

  before :all do
    @student1 = FactoryGirl.create(:student,
            :first_name => 'Alexander',
            :last_name  => 'Zeier',
            :education => 'SAP'
            )

    # @student2 = FactoryGirl.create(:student,
    #         :first_name => 'Maria',
    #         :last_name  => 'Müller',
    #         :education => 'SAP')

  end

	it "should contain all attributes of a student  " do
    visit edit_student_path(@student1)
     page.should have_content(
    "First name",
    "Last name"
    )
     #fill_in ':last_name', with: 'NewName'
  end

  it "should be possible to change name of student1 " do
    visit edit_student_path(@student1)
    fill_in 'student_first_name', :with => 'Agathe'
    fill_in 'student_last_name', :with => 'Ackermann'
    find('input[type="submit"]').click
  
    current_path.should == student_path(@student1)

    page.should have_content(
    "Student was successfully updated",
    "First name",
    "Last name"
    )
  # @student1.first_name.should == "Alexander"
  # geschieht auf Factory girl models tatsächlich eine update operation?
     #fill_in ':last_name', with: 'NewName'
  end



  after(:all) do
    Student.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end


end


describe "the students profile page" do

  before :all do
    @student1 = FactoryGirl.create(:student,
            :first_name => 'Alexander',
            :last_name  => 'Zeier',
            :education => 'SAP'
            )

     @student2 = FactoryGirl.create(:student,
            :first_name => 'Maria',
            :last_name  => 'Müller',
            :education => 'SAP'
        )
  end


  it "should contain all the details of student1" do
      visit student_path(@student1)
      page.should have_content(
        @student1.first_name,
        @student1.last_name,
        @student1.education,
        @student1.programming_languages,
        "Alexander",
        "Zeier"
      )
    end


  it "should contain all the details of student2" do
      visit student_path(@student2)
      page.should have_content(
        @student2.first_name,
        @student2.last_name,
        @student2.education,
        @student2.programming_languages,
        "Maria",
        "Müller"
      )
    end

  it "should have a Back link which leads to the students overview" do
      visit student_path(@student1)

     page.find_link('Back').click
      page.current_path.should == students_path
  end

  it "should have a Edit link which leads to the students edit page" do
      visit student_path(@student1)

     page.find_link('Edit').click
      page.current_path.should == edit_student_path(@student1)
  end

    after(:all) do
      Student.delete_all
      Language.delete_all
      ProgrammingLanguage.delete_all
    end
end
