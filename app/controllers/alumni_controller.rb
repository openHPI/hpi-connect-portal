class AlumniController < ApplicationController
  authorize_resource except: [:register, :link, :link_new, :show]
  skip_before_filter :signed_in_user, only: [:register, :link, :link_new, :index, :show]
  before_action :set_alumni, only: [:show]

  has_scope :firstname, only: [:index], as: :firstname
  has_scope :lastname, only: [:index], as: :lastname
  has_scope :email, only: [:index], as: :email
  has_scope :alumni_email, only: [:index], as: :alumni_email

  def index
    authorize! :index, Alumni
    @alumnis = apply_scopes(Alumni.all).sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 20)
  end

  def show
    authorize! :show, @alumni
  end

  def new
    @alumni = Alumni.new
  end

  def create
    alumni = Alumni.create_from_row alumni_params
    if alumni == :created
      respond_and_redirect_to new_alumni_path, 'Alumni erfolgreich erstellt!'
    else
      @alumni = alumni
      render 'new'
    end
  end

  def create_from_csv
    require 'csv'
    if params[:alumni_file].present?
      count, errors = 0, []
      CSV.foreach(params[:alumni_file].path, headers: true, header_converters: :symbol) do |row|
        count += 1
        alumni = Alumni.create_from_row row
        errors << alumni.errors.full_messages.first + '(' + count.to_s + ')' unless alumni == :created
      end
      if errors.any?
        notice = { error: 'The following lines (starting from 1) contain errors: ' + errors.join(', ')}
      else
        notice = 'Alumni erfolgreich importiert!'
      end
    end
    respond_and_redirect_to new_alumni_path, notice
  end

  def remind_via_mail
  end

  def remind_all
    Alumni.all.each do |alumni|
      alumni.send_reminder
    end
    respond_and_redirect_to alumni_index_path, "Erinnerungsemails gesendet"
  end

  def send_mail_from_csv
    require 'csv'
    if params[:email_file].present?
      count, errors = 0, []
      CSV.foreach(params[:email_file].path, headers: true, header_converters: :symbol) do |row|
        count += 1
        alumni = Alumni.where("lower(alumni_email) = ?", row[:alumni_email].downcase).first
        if alumni.nil?
          errors << "Could not find Alumni " + '(' + count.to_s + ')' unless alumni == :created
        else
          AlumniMailer.creation_email(alumni).deliver
        end
      end
      if errors.any?
        notice = { error: 'The following lines (starting from 1) contain errors: ' + errors.join(', ')}
      else
        notice = 'Alumni Emails erfolgreich gesendet!'
      end
    end
    respond_and_redirect_to remind_via_mail_alumni_index_path, notice
  end

  def register
    @alumni = Alumni.find_by_token! params[:token]
    @user = User.new
  end

  def link
    alumni = Alumni.find_by_token! params[:token]
    user = User.find_by_email params[:session][:email]
    if user && user.authenticate(params[:session][:password])
      alumni.link user
      sign_in user
      if Alumni.email_invalid? params[:session][:email]
        respond_and_redirect_to edit_user_path(user), {error: I18n.t('alumni.choose_another_email')} and return
      end
      respond_and_redirect_to user.manifestation, 'Alumni-Email erfolgreich hinzugefügt!'
    else
      flash[:error] = 'Invalid email/password combination'
      redirect_to alumni_email_path(token: params[:token])
    end
  end

  def link_new
    @alumni = Alumni.find_by_token! params[:token]

    if Alumni.email_invalid? link_params[:email]
      respond_and_redirect_to alumni_email_path(token: @alumni.token), {error: I18n.t('alumni.choose_another_email')} and return
    end

    if User.where("lower(alumni_email) LIKE ?", @alumni.alumni_email.downcase).exists?
      respond_and_redirect_to alumni_email_path(token: @alumni.token), {error: I18n.t('alumni.already_registered')} and return
    end

    @user = User.new link_params
    student = Student.create! academic_program_id: Student::ACADEMIC_PROGRAMS.index('alumnus')
    @user.manifestation = student
    if @user.save
      @alumni.link @user
      sign_in @user
      StudentsMailer.new_student_email(@user.manifestation).deliver
      respond_and_redirect_to [:edit, @user.manifestation], I18n.t('users.messages.successfully_created')
    else
      student.destroy
      render 'register'
    end
  end

  private
    def set_alumni
      @alumni = Alumni.find params[:id]
    end

    def alumni_params
      params.require(:alumni).permit(:firstname, :lastname, :email, :alumni_email)
    end

    def link_params
      params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
    end
end
