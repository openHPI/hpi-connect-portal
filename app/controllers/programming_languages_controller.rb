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

    if @programming_language.save
      respond_and_redirect_to(@programming_language, 'Programming language was successfully created.', 'show', :created)
    else
      render_errors_and_action(@programming_language, 'new')
    end
  end

  # PATCH/PUT /programming_languages/1
  # PATCH/PUT /programming_languages/1.json
  def update
    if @programming_language.update(programming_language_params)
      respond_and_redirect_to(@programming_language, 'Programming language was successfully updated.')
    else
      render_errors_and_action(@programming_language, 'edit')
    end
  end

  # DELETE /programming_languages/1
  # DELETE /programming_languages/1.json
  def destroy
    @programming_language.destroy
    respond_and_redirect_to(programming_languages_url, 'Programming language has been successfully deleted.')
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
