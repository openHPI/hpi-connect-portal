require 'spec_helper'

describe RatingsController do

  let(:student)  { FactoryGirl.create(:student)  }
  let(:employer) { FactoryGirl.create(:employer) }
  

  describe "GET index" do
    
    let!(:employer_ratings) { FactoryGirl.create_list(:rating, 5, employer: employer, student: student) }
    
    context "as student" do
      it "should index all ratings of a specific employer" do
        login student.user
        get :index, { employer_id: employer.id }
        
        expect(assigns(:ratings)).to match_array(employer_ratings)
        assert_template :index
      end  
    end
    
    context "as staff" do
      it "should not index any ratings" do
        staff = employer.staff_members.first
        login staff.user
        get :index, { employer_id: employer.id }
        expect(response).to redirect_to(root_path)
      end
    end
    
    context "as guest user" do
      it "should not index any ratings" do
        staff = employer.staff_members.first
        get :index, { employer_id: employer.id }
        expect(response).to redirect_to(root_path)
      end
    end
    
  end

end