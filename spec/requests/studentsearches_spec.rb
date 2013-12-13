require 'spec_helper'
describe "Studentsearches" do
    before :all do
        ruby = ProgrammingLanguage.new(:name => 'Ruby')
        @student1 = FactoryGirl.create(:user,
            :firstname => 'Alexander',
            :lastname  => 'Zeier',
            :education => 'SAP',
            :programming_languages => [ruby]
        )

        @student2 = FactoryGirl.create(:user,
            :firstname => 'Maria',
            :lastname  => 'Müller',
            :education => 'SAP',
            :programming_languages => [ruby]
        )

        @student3 = FactoryGirl.create(:user,
            :firstname => 'Rafael',
            :lastname  => 'Althofer',
            :education => 'Telekom',
            :programming_languages => [ruby]
        )

        @student4 = FactoryGirl.create(:user,
            :firstname => 'Sara',
            :lastname  => 'Müller',
            :education => 'Telekom',
            :programming_languages => [ruby]
        )
    end

    it 'returns Alexander Zeier' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'Zeier'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_no_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'returns Alexander Zeier and Maria Müller' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'SAP'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.firstname} #{@student1.lastname}"
        expect(page).to have_content "#{@student2.firstname} #{@student2.lastname}"
        expect(page).to have_no_content "#{@student3.firstname} #{@student3.lastname}"
        expect(page).to have_no_content "#{@student4.firstname} #{@student4.lastname}"
    end

    it 'returns Sara Müller and Maria Müller' do
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
        fill_in 'q', :with => 'ORACLE'
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
  after(:all) do
    User.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end
end
