# == Schema Information
#
# Table name: ratings
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  employer_id             :integer
#  job_offer_id            :integer
#  headline                :string(255)
#  description             :text
#  score_overall           :integer
#  score_atmosphere        :integer
#  score_salary            :integer
#  score_work_life_balance :integer
#  score_work_contents     :integer
#

require 'rails_helper'

describe RatingsController do

  let(:student)  { FactoryBot.create(:student)  }
  let(:employer) { FactoryBot.create(:employer) }
  let!(:employer_ratings) { FactoryBot.create_list(:rating, 5, employer: employer, student: student) }
  subject(:staff) { employer.staff_members.first }

  describe "GET index" do

    context "as student" do
      it "indexes all ratings of a specific employer" do
        login student.user
        get :index, params: { employer_id: employer.id }

        expect(assigns(:ratings)).to match_array(employer_ratings)
        assert_template :index
      end
    end

    context "as staff" do
      it "redirects to root path" do
        login staff.user
        get :index, params: { employer_id: employer.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context "as guest user" do
      it "redirects to root path" do
        get :index, params: { employer_id: employer.id }
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
            delete :destroy, params: { employer_id: employer.id, id: del_rating.id }
          }.to change(Rating, :count).by(-1)
        end
      end

      context "not as rating owner" do
        it "doesn't destroy the rating from the database" do
          other_student = FactoryBot.create(:student)
          login other_student.user
          expect {
            delete :destroy, params: { employer_id: employer.id, id: del_rating.id }
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
        put :update, params: { employer_id: employer.id, id: up_rating.id, rating: up_rating.attributes }
        up_rating.headline = 'Another update!'
        expect(up_rating.reload.headline).to eq('This headline was updated!')
      end

      it "returns errors in case of invalid attributes" do
        login student.user
        up_rating.score_overall = 10000
        put :update, params: { employer_id: employer.id, id: up_rating.id, rating: up_rating.attributes }

        expect(assigns(:rating).errors.empty?).to_not be true
      end
    end

    context "as staff" do
      it "doesn't update valid attributes" do
        old_headline = 'Rating headline'
        login staff.user
        up_rating.headline = 'Best Job ever!'
        put :update, params: { employer_id: employer.id, id: up_rating.id, rating: up_rating.attributes }
        expect(up_rating.reload.headline).to eq(old_headline)
      end
    end
  end

  describe "POST create" do

    subject(:new_rating) { FactoryBot.build(:rating) }

    context "as student" do
      before :each do
        login student.user
      end

      it "creates a new rating" do
        expect{
            post :create, params: { employer_id: new_rating.employer.id, rating: new_rating.attributes }
          }.to change(Rating, :count).by(1)
      end

      it "doesn't create a new rating with invalid attributes" do
        new_rating.score_overall = 0
        expect{
            post :create, params: { employer_id: new_rating.employer.id, rating: new_rating.attributes }
          }.to change(Rating, :count).by(0)
      end
    end

    context "as staff" do
      it "doesn't create a new rating" do
        login staff.user
        expect{
            post :create, params: { employer_id: new_rating.employer.id, rating: new_rating.attributes }
          }.to change(Rating, :count).by(0)
      end
    end
  end

end
