require 'spec_helper'

describe "Job Offer pages" do

  subject { page }
  
  describe "show page" do
    describe "open job offer" do
      let(:job_offer) { FactoryGirl.create(:joboffer, responsible_user: FactoryGirl.create(:user), status: FactoryGirl.create(:job_status, :name => "open")) }

      before { visit job_offer_path(job_offer) }

      describe "application button and list" do
        let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
        let(:research_assistant_role) { FactoryGirl.create(:role, name: 'Research Assistant', level: 2) }
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

          it { should have_button('Accept') }
          it { should have_button('Decline') }

          it "is possible to mark a job as completed" do
            should have_link 'Job completed'

            visit edit_job_offer_path(job_offer)
            should have_link 'Job completed'
          end
          
        end
      end
    end

    describe "pending job offer" do
      let(:chair) { FactoryGirl.create(:chair, deputy: FactoryGirl.create(:user) ) }
      let(:job_offer) { FactoryGirl.create(:joboffer, responsible_user: FactoryGirl.create(:user), chair: chair) }
      
      describe "when being a student" do 
        it "should not be visible in the job offers list" do
          get :show, {:id => job_offer.to_param}, valid_session
          response.should redirect_to(job_offers_path) 
        end
      end

      describe "when being a research assistant of the job offers chair" do
        let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: chair) }

        before do
          login_as(research_assistant, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it "should be visible in a read-only mode" do
          should have_link('Edit', :disable => true)
          should have_link('Delete', :disable => true)
        end

        it "should be editable for the responsible user" do
          should have_link('Edit', :disable => false)
          should have_link('Delete', :disable => false)

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
          should have_link('Edit', :disable => false)
          should have_link('Delete', :disable => false)

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