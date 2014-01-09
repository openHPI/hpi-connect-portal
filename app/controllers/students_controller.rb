class StudentsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @users = User.students
    @users = @users.paginate(:page => params[:page], :per_page => 5 )
  end

  # GET /students/1
  # GET /students/1.json
  def show
     user = User.find(params[:id])
    if user.student?
      @user = user
    else
      nil
    end
  end

  # GET /students/new
  def new
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
    @user = User.new
  end

  # GET /students/1/edit
  def edit
    @all_programming_languages = ProgrammingLanguage.all
    @all_languages = Language.all
  end

  #Outdated by new design, at least till know
  # POST /students
  # POST /students.json
  # def create
  #   @user = user.new(user_params)
  #   respond_to do |format|
  #     if @user.save
  #       if params[:programming_languages]

  #         programming_languages = params[:programming_languages]
  #         programming_languages.each do |programming_language_id, skill|
  #           programming_language_user = ProgrammingLanguagesuser.new
  #           programming_language_user.user_id = @user.userid
  #           programming_language_user.programming_language_id = programming_language_id
  #           programming_language_user.skill = skill
  #           programming_language_user.save
  #         end
  #       end
  #       format.html { redirect_to student_path(@user.id), notice: 'user was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @user }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    update_and_remove_for_language(params[:programming_languages], params[:id], ProgrammingLanguagesUser, "programming_language_id")
    update_and_remove_for_language(params[:languages], params[:id], LanguagesUser, "language_id")

    if @user.update(user_params)
      respond_and_redirect_to(student_path(@user), 'User was successfully updated.')
    else
      render_errors_and_redirect_to(student_path(@user), 'edit')
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @user.destroy
    respond_and_redirect_to(students_url, 'Student has been successfully deleted.')
  end

  # GET /students/matching
  def matching 
    #XXX should be a list of strings not [string]
    @users = User.search_students_by_language_and_programming_language(
      params[:languages], params[:programming_languages])
    @users = @users.paginate(:page => params[:page], :per_page => 10 )
    render "index"
  end

  def update_role
    role = Role.find_by_name(params[:role])
    @user = User.find(params[:student_id])
    @user.update(:role_id => role.id) 
    case role.level
      when 2
        @user.update(:chair_id => current_user.chair_id)
      when 3
      when 4
        @user.update(:chair_id => current_user.chair_id)
        Chair.find(current_user.chair_id).update(:deputy_id => @user.id)
        current_user.update(:role_id => Role.find_by_level(2).id)
    end 
      redirect_to(students_path)

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email,
        :firstname, :lastname, :semester, :academic_program,
        :birthday, :education, :additional_information, :homepage,
        :github, :facebook, :xing, :photo, :cv, :linkedin, :status,
        :language_ids => [])
    end

    def update_and_remove_for_language(params, user_id, language_class, language_id_attribute)
      if params
        params.each do |id, skill|
          l = language_class.where("user_id = ? AND " + language_id_attribute + " = ?", user_id, id).first || language_class.create!(:user_id => user_id, language_id_attribute.to_sym => id)
          l.update_attributes(:skill => skill)
        end

        #Delete all programming languages which have been deselected (rating removed) from the form
        language_class.where(:user_id => user_id).each do |l|
          if params[l.attributes[language_id_attribute].to_s].nil?
            l.destroy
          end
        end
      else
        #If the User deselects all languages, they have to be destroyed
        language_class.destroy_all(:user_id => user_id)
      end
    end

end