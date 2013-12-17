require 'spec_helper'

describe "Job Offer pages" do

  subject { page }

  let(:research_assistant_role) { FactoryGirl.create(:role, name: 'Research Assistant', level: 2) }
  before(:each) do
    @status_pending = FactoryGirl.create(:job_status, name:'pending')
    @status_open = FactoryGirl.create(:job_status, name:'open')
    @status_working = FactoryGirl.create(:job_status, name:'working')
    @status_complete = FactoryGirl.create(:job_status, name:'complete')
  end
  
  describe "show page" do
    describe "open job offer" do
      let(:job_offer) { FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:user), status: @status_open) }

      before { visit job_offer_path(job_offer) }

      describe "application button and list" do
        let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
        let(:student) { FactoryGirl.create(:user, role: student_role) }

        describe "without being signed in" do
          it { should_not have_button('Apply') }
          it { should_not have_selector('h4', text: 'Applications') }
        end

        describe "when being a student" do
          before do 
            login_as(student, :scope => :user)
            visit job_offer_path(job_offer)
          end

          it { should have_button('Apply') }
          it { should_not have_selector('h4', text: 'Applications') }

          describe "and having applied already" do
            before do 
              FactoryGirl.create(:application, user: student, job_offer: job_offer)
              login_as(student, :scope => :user)
              visit job_offer_path(job_offer)
            end

            it { should_not have_button('Apply') }
            it { should_not have_selector('h4', text: 'Applications') }
          end
        end

        describe "when being a research assistant of the job offers chair" do
          let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: job_offer.chair) }

          before do
            FactoryGirl.create(:application, job_offer: job_offer)
            login_as(research_assistant, :scope => :user)
            visit job_offer_path(job_offer)
          end

          it { should_not have_button('Apply') }
          it { should have_selector('h4', text: 'Applications') }

          it { should have_link('Accept') }
          it { should have_link('Decline') }

          it "is possible to mark a job as completed" do
            should have_link 'Job completed'

            visit edit_job_offer_path(job_offer)
            should have_link 'Job completed'
          end          
        end
      end
    end

    describe "pending job offer" do

      let(:deputy) { FactoryGirl.create(:user, role: research_assistant_role)}
      let(:chair) { FactoryGirl.create(:chair, deputy: deputy ) }
      let(:job_offer) { FactoryGirl.create(:job_offer, responsible_user: FactoryGirl.create(:user), chair: chair) }
     
      let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
      let(:student) { FactoryGirl.create(:user, role: student_role) }

      before do
        deputy.update(:chair => chair)
      end
      
      describe "when being a student" do
        before(:each) do
          login_as(student, :scope => :user)          
        end 

        it "should not be visible in the job offers list" do
          visit job_offers_path
          should_not have_content(job_offer.title)
        end
        it "should be redirected to the index page" do

          visit job_offer_path(job_offer)
          expect(current_path).to eq(job_offers_path)
        end
      end

      describe "when being a research assistant of the job offers chair" do
        let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: chair) }

        before do
          job_offer.update(responsible_user: research_assistant)
          login_as(research_assistant, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it "should be visible in a read-only mode" do
          should have_selector 'a:contains("Edit"):disabled'
          should have_selector 'a:contains("Delete"):disabled'

          should have_content('pending')
        end

        it "should be editable for the responsible user" do
          should have_selector 'a:contains("Edit"):not(disabled)'
          should have_selector 'a:contains("Delete"):not(disabled)'

          should have_content('pending')

          click_on "Edit"
          expect(current_path).to eq(edit_job_offer_path(job_offer))
        end
      end

      describe "when being the deputy of the chair" do 
        before do          
          login_as(deputy, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it "should be editable for the deputy" do
          should have_selector 'a:contains("Edit"):not(disabled)'
          should have_selector 'a:contains("Delete"):not(disabled)'

          should have_content('pending')

          click_on "Edit"
          expect(current_path).to eq(edit_job_offer_path(job_offer))
        end

        it "is possible to accept or decline the job offer" do
          
          should have_link('Accept')
          should have_link('Decline')
        end
      end
    end
  end
end