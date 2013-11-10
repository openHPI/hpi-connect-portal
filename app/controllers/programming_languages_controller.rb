class ProgrammingLanguagesController < ApplicationController
  before_action :set_programming_language, only: [:show, :edit, :update, :destroy]

  # GET /programming_languages
  # GET /programming_languages.json
  def index
    @programming_languages = ProgrammingLanguage.all
  end

  # GET /programming_languages/1
  # GET /programming_languages/1.json
  def show
  end

  # GET /programming_languages/new
  def new
    @programming_language = ProgrammingLanguage.new
  end

  # GET /programming_languages/1/edit
  def edit
  end

  # POST /programming_languages
  # POST /programming_languages.json
  def create
    @programming_language = ProgrammingLanguage.new(programming_language_params)

    respond_to do |format|
      if @programming_language.save
        format.html { redirect_to @programming_language, notice: 'Programming language was successfully created.' }
        format.json { render action: 'show', status: :created, location: @programming_language }
      else
        format.html { render action: 'new' }
        format.json { render json: @programming_language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /programming_languages/1
  # PATCH/PUT /programming_languages/1.json
  def update
    respond_to do |format|
      if @programming_language.update(programming_language_params)
        format.html { redirect_to @programming_language, notice: 'Programming language was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @programming_language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programming_languages/1
  # DELETE /programming_languages/1.json
  def destroy
    @programming_language.destroy
    respond_to do |format|
      format.html { redirect_to programming_languages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programming_language
      @programming_language = ProgrammingLanguage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def programming_language_params
      params.require(:programming_language).permit(:name)
    end
end
