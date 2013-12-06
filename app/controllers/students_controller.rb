class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @all_programming_languages = ProgrammingLanguage.all
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    @all_programming_languages = ProgrammingLanguage.all
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)
    respond_to do |format|
      if @student.save
        if params[:programming_languages]

          programming_languages = params[:programming_languages]
          programming_languages.each do |programming_language_id, skill|
            programming_language_student = ProgrammingLanguagesStudent.new
            programming_language_student.student_id = @student.id
            programming_language_student.programming_language_id = programming_language_id
            programming_language_student.skill = skill
            programming_language_student.save
          end
        end
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render action: 'show', status: :created, location: @student }
      else
        format.html { render action: 'new' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    if params[:programming_languages]
      programming_languages = params[:programming_languages]
      programming_languages.each do |programming_language_id, skill|
        pl = ProgrammingLanguagesStudent.find_by_student_id_and_programming_language_id(params[:id],programming_language_id)
        if pl
          pl.update_attributes(:skill => skill)
        else
          programming_language_student = ProgrammingLanguagesStudent.new
          programming_language_student.student_id = params[:id]
          programming_language_student.programming_language_id = programming_language_id
          programming_language_student.skill = skill
          programming_language_student.save
        end 
      end
    end
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  # GET /students/matching
  def matching 
    @students = Student.search_students_by_language_and_programming_language(params[:languages], params[:programming_languages])
    render "index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(
        :first_name, :last_name, :semester, :academic_program,
        :birthday, :education, :additional_information, :homepage,
        :github, :facebook, :xing, :photo, :cv, :linkedin, :status,
        :language_ids => [])
    end

end