class StudentsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @users = User.where(is_student: true)
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
    @user = User.new
  end

  # GET /students/1/edit
  def edit
    @all_programming_languages = ProgrammingLanguage.all
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
    if params[:programming_languages]
      programming_languages = params[:programming_languages]
      programming_languages.each do |programming_language_id, skill|
        pl = ProgrammingLanguagesUser.find_by_user_id_and_programming_language_id(params[:id],programming_language_id)
        if pl
          pl.update_attributes(:skill => skill)
        else
          programming_language_user = ProgrammingLanguagesUser.new
          programming_language_user.user_id = params[:id]
          programming_language_user.programming_language_id = programming_language_id
          programming_language_user.skill = skill
          programming_language_user.save
        end
      end
      #Delete all programming languages which have been deselected (rating removed) from the form
      ProgrammingLanguagesUser.where(:user_id => params[:id]).each do |pl|
        if programming_languages[pl.programming_language_id.to_s].nil?
          pl.destroy
        end
      end
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to student_path(@user.id), notice: 'user was successfully updated.' }
        format.json {head :ok }
      else
        format.html { render action: 'edit' }
        format.json { redirect_to student_path(@user.id), status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  # GET /students/matching
  def matching 
    #XXX should be a list of strings not [string]
    @users = User.search_students_by_language_and_programming_language(
      [params[:languages]], [params[:programming_languages]])
    @users = @users.paginate(:page => params[:page], :per_page => 10 )
    render "index"
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

end