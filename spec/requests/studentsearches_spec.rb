require 'spec_helper'
describe "Studentsearches" do
    
    before :each do   
        @student = FactoryGirl.create(:student,
            :first_name => 'Alexander',
            :last_name  => 'Zeier',
            :education => 'accenture'
        )
    end

    it 'when searched for full-text attribute' do
        visit studentsearch_index_path
        fill_in 'q', :with => 'CC'
        find('input[type="submit"]').click
        expect(page).to have_content "#{@student.first_name} #{@student.last_name}"
    end

end
