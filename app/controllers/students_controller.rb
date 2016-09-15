# == Schema Information
#
# Table name: students
#
#  id                        :integer          not null, primary key
#  semester                  :integer
#  academic_program          :string(255)
#  education                 :text
#  additional_information    :text
#  birthday                  :date
#  homepage                  :string(255)
#  github                    :string(255)
#  facebook                  :string(255)
#  xing                      :string(255)
#  linkedin                  :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  employment_status_id      :integer          default(0), not null
#  frequency                 :integer          default(1), not null
#  academic_program_id       :integer          default(0), not null
#  graduation_id             :integer          default(0), not null
#  visibility_id             :integer          default(0), not null
#  dschool_status_id         :integer          default(0), not null
#  group_id                  :integer          default(0), not null
#  hidden_title              :string(255)
#  hidden_birth_name         :string(255)
#  hidden_graduation_id      :integer
#  hidden_graduation_year    :integer
#  hidden_private_email      :string(255)
#  hidden_alumni_email       :string(255)
#  hidden_additional_email   :string(255)
#  hidden_last_employer      :string(255)
#  hidden_current_position   :string(255)
#  hidden_street             :string(255)
#  hidden_location           :string(255)
#  hidden_postcode           :string(255)
#  hidden_country            :string(255)
#  hidden_phone_number       :string(255)
#  hidden_comment            :string(255)
#  hidden_agreed_alumni_work :string(255)
#

class StudentsController < ApplicationController
  include UsersHelper

  skip_before_filter :signed_in_user, only: [:new, :create]

  authorize_resource except: [:destroy, :edit, :index]
  before_action :set_student, only: [:show, :edit, :update, :destroy, :activate]

  has_scope :filter_students, only: [:index], as: :q
  has_scope :filter_programming_languages, type: :array, only: [:index], as: :programming_language_ids
  has_scope :filter_languages, type: :array, only: [:index], as: :language_ids
  has_scope :filter_semester, only: [:index],  as: :semester
  has_scope :filter_employer, only: [:index],  as: :employer
  has_scope :filter_academic_program, only: [:index],  as: :academic_program_id
  has_scope :filter_graduation, only: [:index],  as: :graduation_id

  def index
    authorize! :index, Student
    if can?(:activate, Student)
      indexedStudents = Student.all
    else
      if current_user.staff?
        if current_user.manifestation.employer.premium?
          indexedStudents = Student.active.visible_for_employers
        else
          indexedStudents = Student.active.visible_for_all
        end
      elsif current_user.student?
        indexedStudents = Student.active.visibile_for_students
      else
        indexedStudents = Student.active.visible_for_all
      end
    end
    @students = apply_scopes(indexedStudents).sort_by{ |user| [user.lastname, user.firstname] }.paginate(page: params[:page], per_page: 20)
  end

  def show
    authorize! :show, @student
    not_found unless @student.activated || @student.user == current_user || can?(:activate, @student)
    @job_offers = @student.assigned_job_offers.paginate page: params[:page], per_page: 5
  end

  def new
    @student = Student.new
    @student.build_user
  end

  def create
    @student = Student.new student_params
    if @student.save
      sign_in @student.user
      flash[:success] = I18n.t('users.messages.successfully_created')
      redirect_to [:edit, @student]
      StudentsMailer.new_student_email(@student).deliver
    else
      render 'new'
    end
  end

  def edit
    authorize! :edit, @student
    @programming_languages = ProgrammingLanguage.all
    @languages = Language.all
    @employers = Employer.all
    @student.cv_jobs.build
    @student.cv_educations.build
  end

  def update
    update_from_params_for_languages params, student_path(@student)

    if @student.update student_params
      respond_and_redirect_to(@student, I18n.t('users.messages.successfully_updated.'))
    else
      render_errors_and_action(@student, 'edit')
    end
  end

  def destroy
    authorize! :destroy, @student
    @student.destroy
    respond_and_redirect_to(students_url, I18n.t('users.messages.successfully_deleted.'))
  end

  def activate
    authorize! :activate, @student
    admin_activation and return if current_user.admin?
    url = 'https://openid.hpi.uni-potsdam.de/user/' + params[:student][:username] rescue ''
    authenticate_with_open_id url, return_to: "#{request.protocol}#{request.host_with_port}#{request.fullpath}" do |result, identity_url|
      if result.successful?
        current_user.update_column :activated, true
        flash[:success] = I18n.t('users.messages.successfully_activated')
      else
        flash[:error] = I18n.t('users.messages.unsuccessfully_activated')
      end
      redirect_to current_user.manifestation
    end
  end

  def export_alumni
    require 'csv'
    send_data Student.export_alumni, filename: "alumni-#{Date.today}.csv"
  end

  private
    def set_student
      @student = Student.find params[:id]
    end

    def student_params
      params[:student].permit(Student.column_names.map(&:to_sym))
    end

    def rescue_from_exception(exception)
      if [:index].include? exception.action
        redirect_to root_path, notice: exception.message
      elsif [:edit, :destroy, :update].include? exception.action
        redirect_to student_path(exception.subject), notice: exception.message
      else
        redirect_to root_path, notice: exception.message
      end
    end

    def admin_activation
      @student.user.update_column :activated, true
      flash[:success] = I18n.t('users.messages.successfully_activated')
      redirect_to @student
    end
end
