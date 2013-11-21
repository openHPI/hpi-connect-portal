require 'spec_helper'
describe "Studentsearches" do
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

        @student3 = FactoryGirl.create(:student,
            :first_name => 'Rafael',
            :last_name  => 'Althofer',
            :education => 'Telekom'
        )

        @student4 = FactoryGirl.create(:student,
            :first_name => 'Sara',
            :last_name  => 'Müller',
            :education => 'Telekom'
        )
    end

    it 'returns Alexander Zeier' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'Zeier'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.first_name} #{@student1.last_name}"
        expect(page).to have_no_content "#{@student2.first_name} #{@student2.last_name}"
        expect(page).to have_no_content "#{@student3.first_name} #{@student3.last_name}"
        expect(page).to have_no_content "#{@student4.first_name} #{@student4.last_name}"
    end

    it 'returns Alexander Zeier and Maria Müller' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'SAP'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.first_name} #{@student1.last_name}"
        expect(page).to have_content "#{@student2.first_name} #{@student2.last_name}"
        expect(page).to have_no_content "#{@student3.first_name} #{@student3.last_name}"
        expect(page).to have_no_content "#{@student4.first_name} #{@student4.last_name}"
    end

    it 'returns Sara Müller and Maria Müller' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'müller'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student4.first_name} #{@student4.last_name}"
        expect(page).to have_content "#{@student2.first_name} #{@student2.last_name}"
        expect(page).to have_no_content "#{@student1.first_name} #{@student1.last_name}"
        expect(page).to have_no_content "#{@student3.first_name} #{@student3.last_name}"
    end

    it 'returns all students' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'ORACLE'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student1.first_name} #{@student1.last_name}"
        expect(page).to have_content "#{@student2.first_name} #{@student2.last_name}"
        expect(page).to have_content "#{@student3.first_name} #{@student3.last_name}"
        expect(page).to have_content "#{@student4.first_name} #{@student4.last_name}"
    end

    it 'does not return a student' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'HPI'
        find('input[type="submit"]').click
        expect(page).to have_no_content "#{@student1.first_name} #{@student1.last_name}"
        expect(page).to have_no_content "#{@student2.first_name} #{@student2.last_name}"
        expect(page).to have_no_content "#{@student3.first_name} #{@student3.last_name}"
        expect(page).to have_no_content "#{@student4.first_name} #{@student4.last_name}"
    end
  after(:all) do
    Student.delete_all
    Language.delete_all
    ProgrammingLanguage.delete_all
  end
end
