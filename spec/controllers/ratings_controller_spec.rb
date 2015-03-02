require 'spec_helper'

describe RatingsController do

  let(:student)  { FactoryGirl.create(:student)  }
  let(:employer) { FactoryGirl.create(:employer) }
  let!(:employer_ratings) { FactoryGirl.create_list(:rating, 5, employer: employer, student: student) }
  subject(:staff) { employer.staff_members.first }

  describe "GET index" do
    
    context "as student" do
      it "indexes all ratings of a specific employer" do
        login student.user
        get :index, { employer_id: employer.id }
        
        expect(assigns(:ratings)).to match_array(employer_ratings)
        assert_template :index
      end  
    end
    
    context "as staff" do
      it "redirects to root path" do
        login staff.user
        get :index, { employer_id: employer.id }
        expect(response).to redirect_to(root_path)
      end
    end
    
    context "as guest user" do
      it "redirects to root path" do
        get :index, { employer_id: employer.id }
        expect(response).to redirect_to(root_path)
      end
    end
  
  end
  
  describe "DELETE destroy" do
    
    subject(:del_rating){ employer_ratings.first }
      
    context "as student" do
      context "as rating owner" do
        it "destroys the rating from the database" do
          login student.user
          expect {
            delete :destroy, { employer_id: employer.id, id: del_rating.id }
          }.to change(Rating, :count).by(-1)
        end
      end
      
      context "not as rating owner" do
        it "doesn't destroy the rating from the database" do
          other_student = FactoryGirl.create(:student)
          login other_student.user    
          expect {
            delete :destroy, { employer_id: employer.id, id: del_rating.id }
          }.to change(Rating, :count).by(0)
        end
      end
    end
  end
  
  describe "PUT update" do
    
    subject(:up_rating){ employer_ratings.first }
    
    context "as student" do
      it "updates valid attributes" do
        login student.user
        up_rating.headline = 'This headline was updated!'
        put :update, { employer_id: employer.id, id: up_rating.id, rating: up_rating.attributes }
        up_rating.headline = 'Another update!'
        expect(up_rating.reload.headline).to eq('This headline was updated!')
      end
      
      it "returns errors in case of invalid attributes" do
        login student.user
        up_rating.score_overall = 10000
        put :update, { employer_id: employer.id, id: up_rating.id, rating: up_rating.attributes }    
                
        expect(assigns(:rating).errors.empty?).to_not be_true 
      end
    end
    
    context "as staff" do
      it "doesn't update valid attributes" do
        old_headline = 'Rating headline'
        login staff.user
        up_rating.headline = 'Best Job ever!'
        put :update, { employer_id: employer.id, id: up_rating.id, rating: up_rating.attributes }
        expect(up_rating.reload.headline).to eq(old_headline)
      end
    end  
  end
  
  describe "POST create" do
    
    subject(:new_rating) { FactoryGirl.build(:rating) }
    
    context "as student" do
      it "creates a new rating" do
        login student.user
        expect{
            post :create, { employer_id: new_rating.employer.id, rating: new_rating.attributes }
          }.to change(Rating, :count).by(1)
      end
    end
    
    context "as staff" do
      it "doesn't create a new rating" do
        login staff.user  
        expect{
            post :create, { employer_id: new_rating.employer.id, rating: new_rating.attributes }
          }.to change(Rating, :count).by(0)
      end
    end
  end
      
end
