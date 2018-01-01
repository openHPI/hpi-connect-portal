# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  semester               :integer
#  academic_program       :string(255)
#  education              :text
#  additional_information :text
#  birthday               :date
#  homepage               :string(255)
#  github                 :string(255)
#  facebook               :string(255)
#  xing                   :string(255)
#  linkedin               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  employment_status_id   :integer          default(0), not null
#  frequency              :integer          default(1), not null
#  academic_program_id    :integer          default(0), not null
#  graduation_id          :integer          default(0), not null
#  visibility_id          :integer          default(0), not null
#  dschool_status_id      :integer          default(0), not null
#  group_id               :integer          default(0), not null
#

require 'rails_helper'

describe StudentsController do

  let(:valid_attributes) { { "semester" => "3", "graduation_id" => Student::GRADUATIONS.index("bachelor"), "academic_program_id" => Student::ACADEMIC_PROGRAMS.index("master") } }

  before(:each) do
    login FactoryGirl.create(:student).user
  end

  let(:staff) { FactoryGirl.create(:staff) }
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  let(:valid_session) { {} }


  describe "GET index" do
    it "assigns all students as @students" do
      login FactoryGirl.create(:user, :admin)

      FactoryGirl.create(:student)
      get :index, {}, valid_session
      expect(assigns(:students)).to eq(Student.all.sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: 1, per_page: 5))
    end
  end

  describe "GET show" do
    it "assigns the requested user as @student" do
      student = FactoryGirl.create(:student)
      get :show, { id: student.to_param }, valid_session
      expect(assigns(:student)).to eq(student)
    end
  end

  describe "GET edit" do
    it "assigns the requested student as @student" do
      student = FactoryGirl.create(:student)
      get :edit, {id: student.to_param}, valid_session
      expect(assigns(:student)).to eq(student)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested student" do
        student = FactoryGirl.create(:student)
        expect_any_instance_of(Student).to receive(:update).with({ "semester" => "5" })
        put :update, {id: student.to_param, student: { semester: 5 }}, valid_session
      end

      it "assigns the requested student as @student" do
        student = FactoryGirl.create(:student)
        put :update, {id: student.to_param, student: valid_attributes}, valid_session
        expect(assigns(:student)).to eq(student)
      end

      it "redirects to the student" do
        student = FactoryGirl.create(:student)
        put :update, {id: student.to_param, student: valid_attributes}, valid_session
        expect(response).to redirect_to(student_path(student))
      end
    end

    describe "with invalid params" do
      it "assigns the student as @student" do
        student = FactoryGirl.create(:student)
        allow_any_instance_of(Student).to receive(:save).and_return(false)
        put :update, {id: student.to_param, student: { semester: -1 }}, valid_session
        expect(assigns(:student)).to eq(student)
      end

      it "re-renders the 'edit' template" do
        student = FactoryGirl.create(:student)
        allow_any_instance_of(Student).to receive(:save).and_return(false)
        put :update, {id: student.to_param, student: { semester: -1 }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PATCH update" do
    before(:each) do
      @student = FactoryGirl.create(:student)
    end

    it "handles nil strings and unrealistic values" do

      params = {
        "additional_information" => nil,
        "birthday" => nil,
        "facebook" => nil,
        "github" => nil,
        "homepage" => nil,
        "linkedin" => nil,
        "photo" => nil,
        "semester" => 100,
        "employer_status_id" => "1",
        "xing" => nil
      }

      patch :update, { id: @student.id, student: params}
      expect(response).to render_template("edit")
    end

    it "handles incomplete birthdate values" do
      params = {
        "birthday(1i)" => "3",
        "birthday(2i)" => "3",
        "birthday(3i)" => ""
      }

      patch :update, { id: @student.id, student: params}
      expect(response).to render_template("edit")
    end

    it "saves uploaded images" do
      test_file = ActionDispatch::Http::UploadedFile.new({
        filename: 'test_picture.jpg',
        type: 'image/jpeg',
        tempfile: fixture_file_upload('/images/test_picture.jpg')
      })

      patch :update, { id: @student.id, student: { user_attributes: { "photo" => test_file } } }
      expect(response).to redirect_to(student_path(@student))
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested student and redirects to students page" do
      student = FactoryGirl.create(:student)
      login FactoryGirl.create(:user, :admin)
      expect {
        delete :destroy, {id: student.to_param}, valid_session
      }.to change(Student, :count).by(-1)
      expect(response).to redirect_to students_path
    end

    it "allows student to delete himself" do
      student = FactoryGirl.create(:student)
      login student.user
      expect {
        delete :destroy, {id: student.to_param}, valid_session
      }.to change(Student, :count).by(-1)
      expect(response).to redirect_to students_path
    end

    it "doesn't allow student to delete other students" do
      student1 = FactoryGirl.create(:student)
      student2 = FactoryGirl.create(:student)
      login student1.user
      expect {
        delete :destroy, {id: student2.to_param}, valid_session
      }.to change(Student, :count).by(0)
      expect(response).to redirect_to student_path(student2)
    end
  end

  describe "POST export_alumni" do
    it "should send a CSV file to an admin" do
      login FactoryGirl.create(:user, :admin)
      post :send_alumni_csv
      expect(response.headers['Content-Type']).to eq "text/csv"
    end

    it "should not send a CSV to a student" do
      login FactoryGirl.create(:student).user
      post :send_alumni_csv
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end

    it "should not send a CSV to a staff member" do
      login FactoryGirl.create(:staff).user
      post :send_alumni_csv
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end
  end

  describe "GET activate" do
    describe "as an admin" do

      before :each do
        login FactoryGirl.create(:user, :admin)
        @student = FactoryGirl.create(:student)
        @student.user.update_column :activated, false
      end

      it "should be accessible" do
        get :activate, ({ id: @student.id })
        expect(response).to redirect_to(@student)
      end

      it "should activate the student" do
        get :activate, ({ id: @student.id })
        @student.reload
        assert @student.user.activated
      end
    end

    describe "as a student" do

      before :each do
        @student = FactoryGirl.create(:student)
        login @student.user
      end

      it "should be accessible for the own profile" do
        get :activate, ({ id: @student.id, student: { username: 'max.mustermann' }})
        expect(response).not_to redirect_to(root_path)
      end

      it "should not be accessible for other profiles" do
        get :activate, ({ id: FactoryGirl.create(:student).id })
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eql("You are not authorized to access this page.")
      end
    end

    it "should not be accessible for staff members" do
      staff = FactoryGirl.create(:staff)
      login staff.user
      get :activate, ({ id: FactoryGirl.create(:student).id })
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end
  end

  describe "PUT update with programming languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:student, valid_attributes)
      @programming_language_1 = FactoryGirl.create(:programming_language)
      @programming_language_2 = FactoryGirl.create(:programming_language)
    end

    it "updates the requested student with an existing programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      expect(@student.programming_languages_users.size).to eq(1)
      expect_any_instance_of(ProgrammingLanguagesUser).to receive(:update_attributes).with({ skill: "2" })
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, programming_language_skills: { @programming_language_1.id.to_s => "2" } }, valid_session
    end

    it "updates the requested student with a new programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, programming_language_skills: { @programming_language_1.id.to_s => "4", @programming_language_2.id.to_s => "2" } }, valid_session
      @student.reload
      expect(@student.programming_languages_users.size).to eq(2)
      expect(@student.programming_languages.first).to eq(@programming_language_1)
      expect(@student.programming_languages.last).to eq(@programming_language_2)
    end

    it "updates the requested student with a removed programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryGirl.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4'), FactoryGirl.create(:programming_languages_user, programming_language_id: @programming_language_2.id, skill: '2')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, programming_language_skills: { @programming_language_1.id.to_s => "2" } }, valid_session
      @student.reload
      expect(@student.programming_languages_users.size).to eq(1)
      expect(@student.programming_languages.first).to eq(@programming_language_1)
    end
  end

  describe "PUT update with languages skills" do
    before(:each) do
      @student = FactoryGirl.create(:student, valid_attributes)
      @language_1 = FactoryGirl.create(:language)
      @language_2 = FactoryGirl.create(:language)
    end

    it "updates the requested student with an existing language" do
      @student.assign_attributes(languages_users: [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      expect(@student.languages_users.size).to eq(1)
      expect_any_instance_of(LanguagesUser).to receive(:update_attributes).with({ skill: "2" })
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "2" } }, valid_session
    end

    it "updates the requested student with a new language" do
      @student.assign_attributes(languages_users: [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "4", @language_2.id.to_s => "2" } }, valid_session
      @student.reload
      expect(@student.languages_users.size).to eq(2)
      expect(@student.languages.first).to eq(@language_1)
      expect(@student.languages.last).to eq(@language_2)
    end

    it "updates the requested student with a removed language" do
      @student.assign_attributes(languages_users: [FactoryGirl.create(:languages_user, student: @student, language: @language_1, skill: '4'), FactoryGirl.create(:languages_user, language_id: @language_2.id, skill: '2')])
      put :update, {id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "2" } }, valid_session
      @student.reload
      expect(@student.languages_users.size).to eq(1)
      expect(@student.languages.first).to eq(@language_1)
    end
  end
end
