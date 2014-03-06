require 'spec_helper'

describe StudentsController do

  let(:valid_attributes) { { "firstname" => "Jane", "lastname" => "Doe", "role" => FactoryGirl.create(:role, :student), "identity_url" => "af", "email" => "test@example", "semester" => "3", "education" => "Master", "academic_program" => "Volkswirtschaftslehre" } }
  login_user FactoryGirl.create(:role, name: 'Student')


  # Programming Languages with a mapping to skill integers
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  let(:valid_session) { {} }

  let(:staff) { FactoryGirl.create(:user, :staff) }

  describe "GET index" do
    it "assigns all user as @users" do
      sign_in staff

      user = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student))
      get :index, {}, valid_session
      assigns(:users).should eq(User.students.paginate(:page => 1, :per_page => 5))
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = FactoryGirl.create(:user)
      get :show, { id: user.to_param }, valid_session
      assigns(:user).should eq(user)
    end

    it "checks if the user is a student" do
      user = FactoryGirl.create(:user, :staff)
      get :show, { id: user.to_param }, valid_session
      response.should redirect_to user_path(user)
    end
  end

  describe "GET edit" do
    it "assigns the requested student as @user" do
      student = FactoryGirl.create(:user)
      get :edit, {:id => student.to_param}, valid_session
      assigns(:user).should eq(student)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = FactoryGirl.create(:user)
        # Assuming there are no other students in the database, this
        # specifies that the Student created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update).with({ "firstname" => "MyString" })
        put :update, {:id => user.to_param, :user => {"firstname" => "MyString" }}, valid_session
      end

      it "assigns the requested student as @user" do
        user = FactoryGirl.create(:user)
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        assigns(:user).should eq(user)
      end

      it "redirects to the student" do
        user = FactoryGirl.create(:user)
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        response.should redirect_to(student_path(user))
      end
    end

    describe "with invalid params" do
      it "assigns the student as @user" do
        student = FactoryGirl.create(:user)
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => student.to_param, :user => { "firstname" => "invalid value" }}, valid_session
        assigns(:user).should eq(student)
      end

      it "re-renders the 'edit' template" do
        student = FactoryGirl.create(:user)
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => student.to_param, :user => { "firstname" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "PATCH update" do
    before do
      @student = FactoryGirl.create(:user)
    end

    it "handles nil strings" do

      params = {
        "academic_program" => nil,
        "additional_information" => nil,
        "birthday" => nil,
        "education" => nil,
        "email" => "alexander.zeier@accenture.com",
        "facebook" => nil,
        "firstname" => "Alexander",
        "github" => nil,
        "homepage" => nil,
        "lastname" => "Zeier",
        "linkedin" => nil,
        "photo" => nil,
        "semester" => nil,
        "user_status_id" => "1",
        "xing" => nil
      }

      patch :update, { :id => @student.id, :user => params}

      response.should render_template("edit")
    end

    it "saves uploaded images" do
      test_file = ActionDispatch::Http::UploadedFile.new({
        :filename => 'test_picture.jpg',
        :type => 'image/jpeg',
        :tempfile => fixture_file_upload('/images/test_picture.jpg')
      })

      patch :update, { :id => @student.id, :user => { "photo" => test_file } }
      response.should redirect_to(student_path(@student))
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested student" do
      user = FactoryGirl.create(:user)
      sign_in FactoryGirl.create(:user, role: FactoryGirl.create(:role, :admin))
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the students profile if access is denied" do
      user = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student))
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(0)
      response.should redirect_to student_path(user)
    end

    it "redirects to the students list" do
      user = FactoryGirl.create(:user)
      sign_in FactoryGirl.create(:user, role: FactoryGirl.create(:role, :admin))
      delete :destroy, {:id => user.to_param}, valid_session
      response.should redirect_to(students_path)
    end
  end

  describe "GET matching" do
    it "finds all users with the requested programming language, and language" do
      @programming_language_1 = FactoryGirl.create(:programming_language)
      @programming_language_2 = FactoryGirl.create(:programming_language)
      @language_1 = FactoryGirl.create(:language)
      @language_2 = FactoryGirl.create(:language)

      @user1 = FactoryGirl.create(:user, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1])
      @user2 = FactoryGirl.create(:user, programming_languages: [@programming_language_1], languages: [@language_1, @language_2])
      FactoryGirl.create(:user, programming_languages: [@programming_language_2], languages: [@language_1])
      FactoryGirl.create(:user, programming_languages: [@programming_language_2], languages: [@language_2])
      @user3 =FactoryGirl.create(:user, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1, @language_2])

      sign_in FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student))
      old_path = current_path
      get :matching, ({:language_ids => [@language_1.id], :programming_language_ids => [@programming_language_1.id]}), valid_session
      assert current_path.should == old_path
      assigns(:users).should eq([@user1,@user2,@user3])
    end
  end

  describe "PUT update with programming languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:user, valid_attributes)
      @programming_language_1 = FactoryGirl.create(:programming_language)
      @programming_language_2 = FactoryGirl.create(:programming_language)
    end
    it "updates the requested student with an existing programming language" do
      @student.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, user: @student, programming_language: @programming_language_1, skill: '4')])
      @student.programming_languages_users.size.should eq(1)
      ProgrammingLanguagesUser.any_instance.should_receive(:update_attributes).with({ :skill => "2" })
      put :update, {:id => @student.to_param, :user => { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "2" }}, valid_session
    end
    it "updates the requested student with a new programming language" do
      @student.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, user: @student, programming_language: @programming_language_1, skill: '4')])
      put :update, {:id => @student.to_param, :user => { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "4", @programming_language_2.id.to_s => "2" }}, valid_session
      @student.reload
      @student.programming_languages_users.size.should eq(2)
      @student.programming_languages.first.should eq(@programming_language_1)
      @student.programming_languages.last.should eq(@programming_language_2)
    end
    it "updates the requested student with a removed programming language" do
      @student.assign_attributes(:programming_languages_users => [FactoryGirl.create(:programming_languages_user, user: @student, programming_language: @programming_language_1, skill: '4'), FactoryGirl.create(:programming_languages_user, programming_language_id: @programming_language_2.id, skill: '2')])
      put :update, {:id => @student.to_param, :user => { "firstname" => "Max" }, :programming_languages => { @programming_language_1.id.to_s => "2" }}, valid_session
      @student.reload
      @student.programming_languages_users.size.should eq(1)
      @student.programming_languages.first.should eq(@programming_language_1)
    end
  end

  describe "PUT update with languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:user, valid_attributes)
      @language_1 = FactoryGirl.create(:language)
      @language_2 = FactoryGirl.create(:language)
    end
    it "updates the requested student with an existing language" do
      @student.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, user: @student, language: @language_1, skill: '4')])
      @student.languages_users.size.should eq(1)
      LanguagesUser.any_instance.should_receive(:update_attributes).with({ :skill => "2" })
      put :update, {:id => @student.to_param, :user => { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "2" }}, valid_session
    end
    it "updates the requested student with a new language" do
      @student.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, user: @student, language: @language_1, skill: '4')])
      put :update, {:id => @student.to_param, :user => { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "4", @language_2.id.to_s => "2" }}, valid_session
      @student.reload
      @student.languages_users.size.should eq(2)
      @student.languages.first.should eq(@language_1)
      @student.languages.last.should eq(@language_2)
    end
    it "updates the requested student with a removed language" do
      @student.assign_attributes(:languages_users => [FactoryGirl.create(:languages_user, user: @student, language: @language_1, skill: '4'), FactoryGirl.create(:languages_user, language_id: @language_2.id, skill: '2')])
      put :update, {:id => @student.to_param, :user => { "firstname" => "Max" }, :languages => { @language_1.id.to_s => "2" }}, valid_session
      @student.reload
      @student.languages_users.size.should eq(1)
      @student.languages.first.should eq(@language_1)
    end
  end
end