require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe StudentsController do

  # This should return the minimal set of attributes required to create a valid
  # Student. As you add validations to Student, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "firstname" => "Jane", "lastname" => "Doe", "role" => Role.create(:name => "Student"), "identity_url" => "af", "email" => "test@example", "semester" => "3", "education" => "Master", "academic_program" => "Volkswirtschaftslehre" } }

  # Programming Languages with a mapping to skill integers
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # StudentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all user as @users" do
      user = User.create! valid_attributes
      get :index, {}, valid_session
      assigns(:users).should eq(User.students.paginate(:page => 1, :per_page => 5))
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get :show, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
    end
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
      student = User.create! valid_attributes
      get :edit, {:id => student.to_param}, valid_session
      assigns(:user).should eq(student)
    end
  end

  #removed create Student button from webpage. Caused by OpenID
  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Student" do
  #       expect {
  #         post :create, {:student => valid_attributes}, valid_session
  #       }.to change(Student, :count).by(1)
  #     end

  #     it "assigns a newly created student as @student" do
  #       post :create, {:student => valid_attributes}, valid_session
  #       assigns(:student).should be_a(Student)
  #       assigns(:student).should be_persisted
  #     end

  #     it "redirects to the created student" do
  #       post :create, {:student => valid_attributes}, valid_session
  #       response.should redirect_to(Student.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved student as @student" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Student.any_instance.stub(:save).and_return(false)
  #       post :create, {:student => { "first_name" => "invalid value" }}, valid_session
  #       assigns(:student).should be_a_new(Student)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Student.any_instance.stub(:save).and_return(false)
  #       post :create, {:student => { "first_name" => "invalid value" }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  # end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = User.create! valid_attributes
        # Assuming there are no other students in the database, this
        # specifies that the Student created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update).with({ "firstname" => "MyString" })
        put :update, {:id => user.to_param, :user => {"firstname" => "MyString" }}, valid_session
      end

      it "assigns the requested student as @user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        assigns(:user).should eq(user)
      end

      it "redirects to the student" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        response.should redirect_to(student_path(user))
      end
    end

    describe "with invalid params" do
      it "assigns the student as @user" do
        student = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => student.to_param, :user => { "firstname" => "invalid value" }}, valid_session
        assigns(:user).should eq(student)
      end

      it "re-renders the 'edit' template" do
        student = User.create! valid_attributes
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
  end

  describe "DELETE destroy" do
    it "destroys the requested student" do
      user = User.create! valid_attributes
      expect {
        delete :destroy, {:id => user.to_param}, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the students list" do
      user = User.create! valid_attributes
      delete :destroy, {:id => user.to_param}, valid_session
      response.should redirect_to(students_path)
    end
  end

  describe "GET matching" do
    it "finds all users with the requested programming language, and language" do
      java = ProgrammingLanguage.new(:name => 'Java')
      php = ProgrammingLanguage.new(:name => 'php')
      german = Language.new(:name => 'German')
      english = Language.new(:name => 'English')

      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [java], languages: [german, english])
      FactoryGirl.create(:user, programming_languages: [php], languages: [german])
      FactoryGirl.create(:user, programming_languages: [php], languages: [english])
      FactoryGirl.create(:user, programming_languages: [java, php], languages: [german, english])

      user = User.search_students_by_language_and_programming_language(["german"], ["Java"])
      get :matching, ({:languages => ["German"], :programming_languages => ["java"]}), valid_session
      assigns(:users).should eq(user)
    end
  end

  #Creating Students is diabled
  # describe "POST create with programming languages skills" do
  #   it "creates a new Student" do
  #     java = ProgrammingLanguage.new(:name => 'Java')
  #     php = ProgrammingLanguage.new(:name => 'PHP')
  #     expect {
  #       post :create, {:student => valid_attributes, :programming_languages => programming_languages_attributes}, valid_session
  #     }.to change(Student, :count).by(1)
  #   end
  # end

  describe "PUT update with programming languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:user, valid_attributes)
      @programming_language_1 = FactoryGirl.create(:programming_language, name: 'Java')
      @programming_language_2 = FactoryGirl.create(:programming_language, name: 'Go')
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
      @language_1 = FactoryGirl.create(:language, name: 'English')
      @language_2 = FactoryGirl.create(:language, name: 'German')
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