require 'spec_helper'
describe "Studentsearches" do
    before do

        @prog_language1 = FactoryGirl.create(:programming_language)
        @prog_language2 = FactoryGirl.create(:programming_language)
        @language = FactoryGirl.create(:language)

        FactoryGirl.create(:role,
            :name => "Admin")
        @admin = FactoryGirl.create(:user,
            :role => Role.where(name: "Admin").first
        )

        @student1 = FactoryGirl.create(:user,
            :firstname => 'Alexander',
            :lastname  => 'Zeier',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1),
            :programming_languages =>[@prog_language1],
            :languages => [@language],
            :semester => 2
            )

        @student2 = FactoryGirl.create(:user,
            :firstname => 'Maria',
            :lastname  => 'Müller',
            :role => FactoryGirl.create(:role, name: 'Student', level: 1),
            :programming_languages =>[@prog_language2],
            :semester => 5
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
        login_as(@admin, :scope => :user)
        visit studentsearch_index_path
    end

    before :each do
        login_as(@admin, :scope => :user)
    end

    it 'returns student Alexander Zeier' do
        fill_in 'q', :with => 'Zeier'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end


    it 'returns student Sara Müller and Maria Müller' do
        fill_in 'q', :with => 'müller'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student4.firstname} #{@student4.lastname}"
        expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"

    end

    it 'returns all students' do
        fill_in 'q', :with => 'oracle'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_content "#{@student4.firstname} #{@student4.lastname}"

    end

    it 'does not return a student' do
        fill_in 'q', :with => 'HPI'
        find('input[type="submit"]').click
        expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'should return Alexander Zeier when searching for programming lanugages' do
        expect(page).to have_content "Programmiersprachen"
        
        find(:css, "#ProgrammingLanguage_[value='"+@prog_language1.name+"']").set(true)  
  

        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'should return Maria Müller when searching for programming languages' do       
        find(:css, "#ProgrammingLanguage_[value='"+@prog_language2.name+"']").set(true)  

        find('input[type="submit"]').click
        expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end


    it 'returns student Alexander Zeier' do
        fill_in 'q', :with => @prog_language1.name
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"

    end

    it 'should return Alexander Zeier when searching for languages' do       
        find(:css, "#Language_[value='"+@language.name+"']").set(true)  

        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'should return Alexander Zeier when searching for semester 2' do       
        fill_in 'semester', :with => '2'

        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'should return Alexander Zeier and Maria Müller when searching for semester 2 and 5' do       
        fill_in 'semester', :with => '2, 5'

        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'should handle fancy semester input' do       
        fill_in 'semester', :with => 'start, end, 123'

        find('input[type="submit"]').click
        expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'should not return anyone when searching for an empty semester' do
        find('input[type="submit"]').click
        expect(page).to have_no_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end
end
