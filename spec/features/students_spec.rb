require 'spec_helper'

describe "the profile page" do

	before :all do
    @student1 = FactoryGirl.create(:user,
            :firstname => 'Alexander',
            :lastname  => 'Zeier',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1),
            :programming_languages =>[FactoryGirl.create(:programming_language, name: 'Python')]
            )

  end

  it "should view only names and status of a student on the overview" do
    visit students_path
    page.should have_content(
      @student1.firstname,
      @student1.lastname,
      # @student1.status
      @student1.semester
    )
  end

  it "should contain a link for showing a profile and it should lead to profile page " do
    visit students_path
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

  after(:all) do
    User.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end

end

describe "the students editing page" do

  before :all do
    @student1 = FactoryGirl.create(:user,
            :firstname => 'Alexander',
            :lastname  => 'Zeier',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1)
            )

  end

	it "should contain all attributes of a student" do
    visit edit_student_path(@student1)
    page.should have_content(
      "Carrier",
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
      "user was successfully updated",
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

  after(:all) do
    User.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end

end

describe "the students profile page" do

  before :all do
    @student1 = FactoryGirl.create(:user,
            :firstname => 'Alexander',
            :lastname  => 'Zeier',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1)
                        )

     @student2 = FactoryGirl.create(:user,
            :firstname => 'Maria',
            :lastname  => 'Müller',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1)
        )
  end


  it "should contain all the details of student1" do
      visit student_path(@student1)
      page.should have_content(
        @student1.firstname,
        @student1.lastname,
      
        # @student1.programming_languages,
        "Alexander",
        "Zeier"
      )
  end

  it "should contain all the details of student2" do
      visit student_path(@student2)
      page.should have_content(
        @student2.firstname,
        @student2.lastname,
        # @student2.programming_languages,
        "Maria",
        "Müller"
      )
  end

  it "should have a Edit link which leads to the students edit page" do
      visit student_path(@student1)
      page.find_link('Edit').click
      page.current_path.should == edit_student_path(@student1)
  end

  after(:all) do
    User.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end
end
