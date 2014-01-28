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
      get :show, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end

#########################################################################################################################
# NOTE: this should be rewritten and reenabled after the correct implementation of redirecting users to their role path #
#########################################################################################################################
    # it "checks if the user is a student" do
    #   user = FactoryGirl.create(:user, :staff)
    #   expect {
    #     get :show, {:id => user.to_param}, valid_session
    #   }.to raise_error(ActionController::RoutingError)
    # end
  end

  #caused by OpenID we cannot create new students anymore by Urls
  # describe "GET new" do
  #   it "assigns a new student as @student" do
  #     get :new, {}, valid_session
  #     assigns(:).should be_a_new(Student)
  #   endstudent
  # end

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
      patch :update, { :id => @student.id, :user => { "photo" => fixture_file_upload('images/test_picture.jpg', 'image/jpeg') } }
      response.should redirect_to(student_path(@student))
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested student" do
      user = FactoryGirl.create(:user)
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the students list" do
      user = FactoryGirl.create(:user)
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

      FactoryGirl.create(:user, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1])
      FactoryGirl.create(:user, programming_languages: [@programming_language_1], languages: [@language_1, @language_2])
      FactoryGirl.create(:user, programming_languages: [@programming_language_2], languages: [@language_1])
      FactoryGirl.create(:user, programming_languages: [@programming_language_2], languages: [@language_2])
      FactoryGirl.create(:user, programming_languages: [@programming_language_1, @programming_language_2], languages: [@language_1, @language_2])

      user = User.search_students_by_language_and_programming_language([@language_1.name], [@programming_language_1.name])
      get :matching, ({:languages => [@language_1.name.capitalize], :programming_languages => [@programming_language_1.name.capitalize]}), valid_session
      assigns(:users).should eq(user)
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

  describe "POST update_role" do
    before(:each) do
        @student_role = FactoryGirl.create(:role, :student)
        @student = FactoryGirl.create(:user, :student, employer: FactoryGirl.create(:employer))
        @staff_role = FactoryGirl.create(:role, :staff)
        @admin_role = FactoryGirl.create(:role, :admin)
        @employer = FactoryGirl.create(:employer)
    end



    describe "beeing the employers deputy" do
      before(:each) do
        sign_in @employer.deputy
      end

      it "updates role to Staff" do
        assert_equal(@student.role, @student_role)
        put :update_role, { student_id: @student.id, role_name: @staff_role.name }, valid_session
        assert_equal(@staff_role, @student.reload.role)
      end

      it "updates role to Deputy" do
        post :update_role, { student_id: @student.id, role_name: "Deputy" }, valid_session
        assert_equal(@student, @employer.deputy)
      end

      it "redirects to student page when invalid new role is transmitted" do
        post :update_role, { student_id: @student.id, role_name: "Doktorand" }, valid_session
        response.should redirect_to(student_path(@student))
      end
    end
 
    describe "beeing an admin" do
      before(:each) do
        sign_in FactoryGirl.create(:user, :admin)
      end

      it "updates role to Staff" do
        post :update_role, { student_id: @student.id, role_name: @staff_role.name, employer_name: @employer.name }, valid_session
        assert_equal(@staff_role, @student.reload.role)
        assert_equal(@employer, @student.reload.employer)
      end

      it "updates role to Deputy" do
        post :update_role, { student_id: @student.id, role_name: "Deputy", employer_name: @employer.name }, valid_session
        assert_equal(@student.reload, @employer.reload.deputy)
        assert_equal(@staff_role, @student.reload.role)
      end

      it "updates role to Admin" do
        post :update_role, { student_id: @student.id, role_name: @admin_role.name }, valid_session
        assert_equal(@admin_role, @student.reload.role)
      end

      it "redirects to student page when invalid new role is transmitted" do
        post :update_role, { student_id: @student.id, role_name: "Doktorand" }, valid_session
        response.should redirect_to(student_path(@student))
      end
    end

    describe "beeing a student" do
      
      before(:each) do
        sign_in FactoryGirl.create(:user, :student)
      end

      it "should not allow updating the role" do
        post :update_role, { student_id: @student.reload.id, role_name: "Deputy", employer_name: @employer.name }, valid_session
        response.should redirect_to(student_path(@student))
      end

    end

  end
end