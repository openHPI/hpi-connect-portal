require 'rails_helper'

describe AlumniController do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:student) { FactoryBot.create(:student) }
  let!(:alumnus) { FactoryBot.create(:alumni) }
  let(:registered_alumnus) { FactoryBot.create(:user, :alumnus) }

  describe "GET new" do
    it "should be available for admins" do
      login admin
      get :new
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login student.user
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET index" do
    it "should be available for admins" do
      login admin
      get :index
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login student.user
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET show" do
    it "should be available for admins" do
      login admin
      get :show, params: { id: FactoryBot.create(:alumni).to_param }
      expect(response).not_to redirect_to(root_path)
    end

    it "should not be available for anyone else" do
      login student.user
      get :show, params: { id: FactoryBot.create(:alumni).to_param }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST create" do
    context "as an admin" do
      before(:each) do
        login admin
      end

      it "creates an alumnus" do
        expect {
            post :create, params: { alumni: FactoryBot.attributes_for(:alumni) }
          }.to change(Alumni, :count).by(1)
      end

      it "re-renders 'new' template if save fails" do
        post :create, params: { alumni: { firstname: 'No', lastname: 'Mail' } }
        expect(response).to render_template('new')
        expect(assigns(:alumni).firstname).to eq('No')
        expect(assigns(:alumni).lastname).to eq('Mail')
      end
    end

    it "should not be available for anyone else" do
      login student.user
      expect {
          post :create, params: { alumni: FactoryBot.attributes_for(:alumni) }
        }.to change(Alumni, :count).by(0)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET remind_all" do
    context "as admin" do
      before(:each) do
        login admin
        FactoryBot.create :alumni
        FactoryBot.create :alumni
      end

      it "redirects to alumni_path" do
        get :remind_all
        expect(response).to redirect_to(alumni_index_path)
      end

      it "sends reminder mails to all alumni" do
        ActionMailer::Base.deliveries = []
        get :remind_all
        expect(ActionMailer::Base.deliveries.count).to eq(Alumni.count)
      end
    end

    it "redirects to root if not admin" do
      login student.user
      get :remind_all
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST link" do
    let(:session_params) { { email: student.email, password: student.user.password } }

    it "calls alumnus.link with the user" do
      expect_any_instance_of(Alumni).to receive(:link).with(student.user)
      post :link, params: { token: alumnus.token, session: session_params }
    end

    it "redirects to student with success message" do
      post :link, params: { token: alumnus.token, session: session_params }
      expect(response).to redirect_to(student)
      expect(flash[:success]).to eq(I18n.t('students.alumni_email_linked'))
    end

    it "redirects to user edit page if email is invalid" do
      student.user.update_attributes email: 'max.mustermann@student.hpi.de'
      post :link, params: { token: alumnus.token, session: session_params }
      expect(response).to redirect_to(edit_user_path(student.user))
      expect(flash[:error]).to eq(I18n.t('alumni.choose_another_email'))
    end

    it "redirects back with error message if session params are invalid" do
      session_params[:password] = 'wrong_password'
      post :link, params: { token: alumnus.token, session: session_params }
      expect(response).to redirect_to(alumni_email_path(alumnus.token))
      expect(flash[:error]).to eq(I18n.t('errors.configuration.invalid_email_or_password'))
    end
  end

  describe "POST link_new" do
    let(:link_params) { { firstname: 'Max', lastname: 'Mustermann', email: 'max@mustermann.de',
                        password: 'password', password_confirmation: 'password' } }

    it "creates a user with specified attributes" do
      expect {
        post :link_new, params: { token: alumnus.token, user: link_params }
      }.to change(User, :count).by(1)
      expect(User.last.firstname).to eq(link_params[:firstname])
      expect(User.last.lastname).to eq(link_params[:lastname])
      expect(User.last.email).to eq(link_params[:email])
      expect(User.last.manifestation.academic_program_id).to eq(Student::ACADEMIC_PROGRAMS.index('alumnus'))
    end

    it "creates a student with alumnus status" do
      expect {
        post :link_new, params: { token: alumnus.token, user: link_params }
      }.to change(Student, :count).by(1)
      expect(Student.last.academic_program_id).to eq(Student::ACADEMIC_PROGRAMS.index('alumnus'))
    end

    it "calls alumnus.link with the created user" do
      user = FactoryBot.create(:user, link_params)
      allow(Alumni).to receive(:find_by_token!).and_return(alumnus)
      allow(User).to receive(:new).and_return(user)
      expect(alumnus).to receive(:link).with(user)
      post :link_new, params: { token: alumnus.token, user: link_params }
    end

    it "redirects to student edit page for created user" do
      user = FactoryBot.create(:user, link_params)
      allow(User).to receive(:new).and_return(user)
      post :link_new, params: { token: alumnus.token, user: link_params }
      expect(response).to redirect_to(edit_student_path(user.manifestation))
      expect(flash[:success]).to eq(I18n.t('users.messages.successfully_created'))
    end

    it "sends mail to admin" do
      ActionMailer::Base.deliveries = []
      post :link_new, params: { token: alumnus.token, user: link_params }
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to[0]).to eq(Configurable[:mailToAdministration])
    end

    it "shows an error message if user email is invalid" do
      link_params[:email] = 'max.mustermann@student.hpi.de'
      post :link_new, params: { token: alumnus.token, user: link_params }
      expect(response).to redirect_to(alumni_email_path(alumnus.token))
      expect(flash[:error]).to eq(I18n.t('alumni.choose_another_email'))
    end

    it "shows an error message if alumnus already has an account" do
      registered_alumnus.update_attributes alumni_email: alumnus.alumni_email
      post :link_new, params: { token: alumnus.token, user: link_params }
      expect(response).to redirect_to(alumni_email_path(alumnus.token))
      expect(flash[:error]).to eq(I18n.t('alumni.already_registered'))
    end

    it "re-renders 'register' template if user save fails" do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      post :link_new, params: { token: alumnus.token, user: link_params }
      expect(response).to render_template('register')
    end

    it "doesn't create a student if user save fails" do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      expect {
        post :link_new, params: { token: alumnus.token, user: link_params }
      }.to change(Student, :count).by(0)
    end
  end
end
