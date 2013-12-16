require 'spec_helper'
describe "Studentsearches" do
    before :all do

   @student1 = FactoryGirl.create(:user,
            :firstname => 'Alexander',
            :lastname  => 'Zeier',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1),
            :programming_languages =>[FactoryGirl.create(:programming_language, name: 'Python')]
            )

        @student2 = FactoryGirl.create(:user,
            :firstname => 'Maria',
            :lastname  => 'Müller',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1)
            #:programming_languages =>[FactoryGirl.create(:programming_language, name: 'C')]
        )

        @student3 = FactoryGirl.create(:user,
            :firstname => 'Rafael',
            :lastname  => 'Althofer',
            :role => FactoryGirl.create(:role, name: 'Research Assistant', level: 1)
        )

        @student4 = FactoryGirl.create(:user,
            :firstname => 'Sara',
            :lastname  => 'Müller',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1)
        )
    end

    it 'returns student Alexander Zeier' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'Zeier'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end


    it 'returns student Sara Müller and Maria Müller' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'müller'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student4.firstname} #{@student4.lastname}"
        expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"

    end

    it 'returns all students' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'oracle'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_content "#{@student4.firstname} #{@student4.lastname}"

    end

    it 'does not return a student' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'HPI'
        find('input[type="submit"]').click
        expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    # it 'should return Alexander Zeier' do
    #     visit studentsearch_index_path
    #     expect(page).to have_content "Programmiersprachen"
        
    #     # find(:css, "#ProgrammingLanguage_[value='Python']").set(true)  
  

    #     # find('input[type="submit"]').click
    #     # expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
    #     # expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
    #     # expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
    #     # expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    # end

    # it 'should return Maria Müller' do
    #     visit studentsearch_index_path
       
    #     find(:css, "#ProgrammingLanguage_[value='C']").set(true)  

    #     find('input[type="submit"]').click
    #     expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
    #     expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
    #     expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
    #     expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    # end


    it 'returns student Alexander Zeier' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'Python'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"

    end


  after(:all) do
    User.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end
end
