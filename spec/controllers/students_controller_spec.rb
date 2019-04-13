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
    login FactoryBot.create(:student).user
  end

  let(:student) { FactoryBot.create(:student) }
  let(:staff) { FactoryBot.create(:staff) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:programming_languages_attributes) { { "1" => "5", "2" => "2" } }

  describe "GET index" do
    before(:all) do
      FactoryBot.create(:student, :visible_for_students)
      FactoryBot.create(:student, :visible_for_employers)
      FactoryBot.create(:student, :visible_for_nobody)
    end

    context "as an admin" do
      before :each do
        login admin
      end

      it "shows all students" do
        get :index
        expect(assigns(:students)).to eq(Student.all.sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: 1, per_page: 20))
      end
    end

    context "as a staff member" do
      before(:each) do
        login staff.user
      end

      it "doesn't show any students" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context "as a staff member of a premium employer" do
      let(:premium_staff) { FactoryBot.create(:staff, :of_premium_employer) }

      before :each do
        login premium_staff.user
      end

      it "shows only students visible for employers" do
        get :index
        expect(assigns(:students)).to eq(Student.active.visible_for_employers.sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: 1, per_page: 20))
      end
    end

    context "as a student" do
      before :each do
        login student
      end

      it "shows only students visible for other students" do
        get :index
        expect(assigns(:students)).to eq(Student.active.visible_for_students.sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: 1, per_page: 20))
      end
    end
  end

  describe "GET show" do
    it "assigns the requested user as @student" do
      student = FactoryBot.create(:student)
      get :show, params: { id: student.to_param }
      expect(assigns(:student)).to eq(student)
    end
  end

  describe "GET edit" do
    it "assigns the requested student as @student" do
      student = FactoryBot.create(:student)
      get :edit, params: { id: student.to_param }
      expect(assigns(:student)).to eq(student)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested student" do
        student = FactoryBot.create(:student)
        expect_any_instance_of(Student).to receive(:update).with({ "semester" => "5" })
        put :update, params: { id: student.to_param, student: { semester: 5 } }
      end

      it "assigns the requested student as @student" do
        student = FactoryBot.create(:student)
        put :update, params: { id: student.to_param, student: valid_attributes }
        expect(assigns(:student)).to eq(student)
      end

      it "redirects to the student" do
        student = FactoryBot.create(:student)
        put :update, params: { id: student.to_param, student: valid_attributes }
        expect(response).to redirect_to(student_path(student))
      end
    end

    describe "with invalid params" do
      it "assigns the student as @student" do
        student = FactoryBot.create(:student)
        allow_any_instance_of(Student).to receive(:save).and_return(false)
        put :update, params: { id: student.to_param, student: { semester: -1 } }
        expect(assigns(:student)).to eq(student)
      end

      it "re-renders the 'edit' template" do
        student = FactoryBot.create(:student)
        allow_any_instance_of(Student).to receive(:save).and_return(false)
        put :update, params: { id: student.to_param, student: { semester: -1 } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "PATCH update" do
    before(:each) do
      @student = FactoryBot.create(:student)
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

      patch :update, params: { id: @student.id, student: params }
      expect(response).to render_template("edit")
    end

    it "handles incomplete birthdate values" do
      params = {
        "birthday(1i)" => "3",
        "birthday(2i)" => "3",
        "birthday(3i)" => ""
      }

      patch :update, params: { id: @student.id, student: params }
      expect(response).to render_template("edit")
    end

    it "saves uploaded images" do
      test_file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/test_picture.jpg'), 'image/jpeg')

      patch :update, params: { id: @student.id, student: { user_attributes: { "photo" => test_file } } }
      expect(response).to redirect_to(student_path(@student))
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested student and redirects to students page" do
      student = FactoryBot.create(:student)
      login FactoryBot.create(:user, :admin)
      expect {
        delete :destroy, params: { id: student.to_param }
      }.to change(Student, :count).by(-1)
      expect(response).to redirect_to students_path
    end

    it "allows student to delete himself" do
      student = FactoryBot.create(:student)
      login student.user
      expect {
        delete :destroy, params: { id: student.to_param }
      }.to change(Student, :count).by(-1)
      expect(response).to redirect_to students_path
    end

    it "doesn't allow student to delete other students" do
      student1 = FactoryBot.create(:student)
      student2 = FactoryBot.create(:student)
      login student1.user
      expect {
        delete :destroy, params: { id: student2.to_param }
      }.to change(Student, :count).by(0)
      expect(response).to redirect_to student_path(student2)
    end
  end

  describe "POST export_alumni" do
    it "should send a CSV file to an admin" do
      login admin
      post :send_alumni_csv, params: { which_alumni: 'registered' }
      expect(response.headers['Content-Type']).to eq "text/csv"
    end

    it "calls Student.export_registered_alumni with specified time span" do
      login admin
      expect(Student).to receive(:export_registered_alumni).with(Date.new(1970,1,1), Date.current)
      post :send_alumni_csv, params: { which_alumni: 'from_to', from_date: {day: 1, month: 1, year: 1970}, to_date: {day: Date.current.day, month: Date.current.month, year: Date.current.year} }
    end

    it "calls Alumni.export_unregistered_alumni" do
      login admin
      expect(Alumni).to receive(:export_unregistered_alumni)
      post :send_alumni_csv, params: { which_alumni: 'unregistered' }
    end

    it "should not send a CSV to a student" do
      login student.user
      post :send_alumni_csv
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end

    it "should not send a CSV to a staff member" do
      login staff.user
      post :send_alumni_csv
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end
  end

  describe "GET activate" do
    before(:each) do
      student.user.update_attributes activated: false
    end

    context "as an admin" do
      before(:each) do
        login admin
      end

      it "redirects to student" do
        get :activate, params: { id: student.id }
        expect(response).to redirect_to(student)
      end

      it "activates the student" do
        expect {
          get :activate, params: { id: student.id }
        }.to change { student.user.reload.activated }.from(false).to(true)
      end
    end

    context "as a student" do
      before(:each) do
        login student.user
        result = double
        identity_url = double
        allow_any_instance_of(StudentsController).to receive(:authenticate_with_open_id).and_yield(result, identity_url)
        allow(result).to receive(:successful?).and_return(true)
      end

      it "redirects to own profile" do
        get :activate, params: { id: student.id, student: { username: 'max.mustermann' } }
        expect(response).to redirect_to(student)
      end

      it "activates the student" do
        expect {
          get :activate, params: { id: student.id }
        }.to change { student.user.reload.activated }.from(false).to(true)
      end

      it "displays a success message" do
        get :activate, params: { id: student.id, student: { username: 'max.mustermann' } }
        expect(flash[:success]).to eq(I18n.t('users.messages.successfully_activated'))
      end

      it "displays an error message if OpenID authentication fails" do
        result = double
        identity_url = double
        allow_any_instance_of(StudentsController).to receive(:authenticate_with_open_id).and_yield(result, identity_url)
        allow(result).to receive(:successful?).and_return(false)
        get :activate, params: { id: student.id, student: { username: 'max.mustermann' } }
        expect(flash[:error]).to eq(I18n.t('users.messages.unsuccessfully_activated'))
      end

      it "is not possible to activate other students" do
        get :activate, params: { id: FactoryBot.create(:student).id, student: { username: 'maria.mustermann' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eql("You are not authorized to access this page.")
      end
    end

    it "should not be accessible for staff members" do
      login staff.user
      get :activate, params: { id: student.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eql("You are not authorized to access this page.")
    end
  end

  describe "PUT update with programming languages skills" do
    before(:each) do
      @student = FactoryBot.create(:student, valid_attributes)
      @programming_language_1 = FactoryBot.create(:programming_language)
      @programming_language_2 = FactoryBot.create(:programming_language)
      @private_programming_language = FactoryBot.create(:programming_language, private: true)
    end

    it "updates the requested student with an existing programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryBot.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      expect(@student.programming_languages_users.size).to eq(1)
      put :update, params: { id: @student.to_param, student: { programming_languages_users_attributes: { id: @student.programming_languages_users.first.id.to_s, skill: "2" } } }
      @student.reload
      expect(@student.programming_languages_users.first.skill).to eq (2)
    end

    it "updates the requested student with a new programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryBot.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4')])
      put :update, params: { id: @student.to_param, student: { programming_languages_users_attributes: { "1" => { id: @student.programming_languages_users.first.id, programming_language_id: @programming_language_1.id.to_s, skill: "3" }, "2" => { programming_language_id: @programming_language_2.id.to_s, skill: "2" } } } }
      @student.reload
      expect(@student.programming_languages_users.size).to eq(2)
      expect(@student.programming_languages.first).to eq(@programming_language_1)
      expect(@student.programming_languages.last).to eq(@programming_language_2)
    end

    it "updates the requested student with a removed programming language" do
      @student.assign_attributes(programming_languages_users: [FactoryBot.create(:programming_languages_user, student: @student, programming_language: @programming_language_1, skill: '4'), FactoryBot.create(:programming_languages_user, programming_language_id: @programming_language_2.id, skill: '2')])
      put :update, params: { id: @student.to_param, student: { programming_languages_users_attributes: { id: @student.programming_languages_users.last.id.to_s, _destroy: 1  } } }
      @student.reload
      expect(@student.programming_languages_users.size).to eq(1)
      expect(@student.programming_languages.first).to eq(@programming_language_1)
    end

    it "deletes a removed programming language only if it is private" do
      @student.assign_attributes(programming_languages_users: [FactoryBot.create(:programming_languages_user, student: @student, programming_language: @private_programming_language, skill: '4'), FactoryBot.create(:programming_languages_user, programming_language_id: @programming_language_2.id, skill: '2')])

      expect{
        put :update, params: { id: @student.to_param, student: { programming_languages_users_attributes: { id: @student.programming_languages_users.first.id.to_s, _destroy: 1  } } }
      }.to change{ProgrammingLanguage.count}.by(-1)

      expect{
        put :update, params: { id: @student.to_param, student: { programming_languages_users_attributes: { id: @student.programming_languages_users.first.id.to_s, _destroy: 1  } } }
      }.to change{ProgrammingLanguage.count}.by(0)
    end
  end

  describe "PUT update with languages skills" do
    before(:each) do
      @student = FactoryBot.create(:student, valid_attributes)
      @language_1 = FactoryBot.create(:language)
      @language_2 = FactoryBot.create(:language)
    end

    it "updates the requested student with an existing language" do
      @student.assign_attributes(languages_users: [FactoryBot.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      expect(@student.languages_users.size).to eq(1)
      expect_any_instance_of(LanguagesUser).to receive(:update_attributes).with({ skill: "2" })
      put :update, params: { id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "2" } }
    end

    it "updates the requested student with a new language" do
      @student.assign_attributes(languages_users: [FactoryBot.create(:languages_user, student: @student, language: @language_1, skill: '4')])
      put :update, params: { id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "4", @language_2.id.to_s => "2" } }
      @student.reload
      expect(@student.languages_users.size).to eq(2)
      expect(@student.languages.first).to eq(@language_1)
      expect(@student.languages.last).to eq(@language_2)
    end

    it "updates the requested student with a removed language" do
      @student.assign_attributes(languages_users: [FactoryBot.create(:languages_user, student: @student, language: @language_1, skill: '4'), FactoryBot.create(:languages_user, language_id: @language_2.id, skill: '2')])
      put :update, params: { id: @student.to_param, student: { academic_program_id: Student::ACADEMIC_PROGRAMS.index("bachelor") }, language_skills: { @language_1.id.to_s => "2" } }
      @student.reload
      expect(@student.languages_users.size).to eq(1)
      expect(@student.languages.first).to eq(@language_1)
    end
  end

  describe "POST create" do
    let(:valid_attributes) { { user_attributes:  { firstname: "Max", lastname: "Mustermann", email: "test@testmail.de",
                                                   password: "test", password_confirmation: "test" } } }

    before(:each) do
      logout
    end

    it "creates student" do
      expect {
        post :create, params: { student: valid_attributes }
      }.to change(Student, :count).by(1)
    end

    it "redirects to new student" do
      post :create, params: { student: valid_attributes }
      expect(response).to redirect_to edit_student_path(Student.last)
    end

    it "shows success message" do
      post :create, params: { student: valid_attributes }
      expect(flash[:success]).to eq(I18n.t('users.messages.successfully_created'))
    end

    it "sends mail to admin" do
      ActionMailer::Base.deliveries = []
      post :create, params: { student: valid_attributes }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to[0]).to eq(Configurable[:mailToAdministration])
    end

    it "re-renders template if save fails" do
      allow_any_instance_of(Student).to receive(:save).and_return(false)
      post :create, params: { student: valid_attributes }
      expect(response).to render_template('new')
    end
  end

  describe "GET new" do
    before :each do
      logout
    end

    it "should render template" do
      get :new
      expect(response).to render_template('new')
    end
  end
end
